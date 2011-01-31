#!/bin/python

# Code based on https://github.com/sbma44/py-gtfs-mysql by user sbma44, modified for import to postgres instead of mysql.


import csv
import pg
import os

def is_numeric(s):
    try:
      i = float(s)
    except ValueError:
        # not numeric
        return False
    else:
        # numeric
        return True

def main():
    #INPUT - SHOULD BE PASSED AT COMMAND LINE
    #Note directory structure: ./gtfs/[agency] contains gtfs zip file, ./schema contains sql to create schema and build indexes
    #Update agency to reflect the folder name containing the gtfs zip file.
    db = 'cccta'
    hst = 'localhost'
    usr = 'gtfs'
    pwd = 'gtfs'
    agency = 'metrotransit'
    schema = 'gtfs'
    con = pg.connect(dbname=db,host=hst,user=usr,passwd=pwd)
    #set up GTFS schema
    con.query("DROP SCHEMA %s cascade; CREATE SCHEMA %s;" % (schema,schema))
    os.system('unzip ./gtfs/%s/google_transit.zip -d ./gtfs/%s/; cat ./schema/gtfs_schema.create.sql | psql -U %s -d %s -h %s -W %s' % (agency,agency,usr,db,hst,pwd))
    TABLES = ['agency', 'calendar', 'calendar_dates', 'fare_attributes','fare_rules','frequencies', 'routes', 'shapes','stop_times','stops','trips']
    #TABLES = ['agency','calendar','calendar_dates']
    for table in TABLES:
        try:
          f = open('gtfs/%s/%s.txt' % (agency,table), 'r')
          print 'processing %s' % table
          reader = csv.reader(f)
          columns = reader.next()
          #print ','.join(columns)
          for row in reader:
              insert_row = []
              for value in row:
                  if not is_numeric(value):
                      insert_row.append("'" + pg.escape_string(value) + "'")
                  else:
                      insert_row.append(value)
              con.query("INSERT INTO %s (%s,_agency_id) VALUES (%s,'%s');" % (table,','.join(columns),','.join(insert_row),agency))
        except IOError:
          print 'NOTICE: %s.txt not provided in feed.' % table
    # create new columns, indexes and constraints
    extra_sql = []
    extra_sql.append('update shapes set the_geom = st_setsrid(st_point(shape_pt_lon,shape_pt_lat),4326);')
    extra_sql.append('update stops set the_geom = st_setsrid(st_point(stop_lon,stop_lat),4326);')
    for sql in extra_sql:
      try:
        con.query(sql)
      except pg.ProgrammingError:
        pass
    os.system('cat ./schema/gtfs_schema.index.sql | psql -U %s -d %s -h %s -W %s' % (usr,db,hst,pwd))

if __name__ == '__main__':
    main()