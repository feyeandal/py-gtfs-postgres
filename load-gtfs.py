#!/bin/python

# Code based on https://github.com/sbma44/py-gtfs-mysql by user sbma44, modified for import to postgres instead of mysql.

import sys
import csv
import pg
import os

#### Next step: get threading working.  These classes will be used eventually.

import threading

class queryThread(threading.Thread):
    def __init__(self,connection,table,columns,data,agency):
      self.connection = connection
      self.table = table
      self.columns = columns
      self.data = data
      self.agency = agency
      threading.Thread.__init__(self)
    def run(self):
      insert_into_table(self.connection,self.table,self.columns,self.data,self.agency)

def is_numeric(s):
    try:
      i = float(s)
    except ValueError:
        # not numeric
        return False
    else:
        # numeric
        return True

####

def insert_into_table(connection,table,columns,data,agency):
   
    #print "con.query(\"INSERT INTO %s (%s,agency_id) VALUES (%s,'%s');\")" % (table,columns,data,agency)
    #print threading.activeCount()
    connection.query("INSERT INTO %s (%s,agency_id) VALUES (%s,'%s');" % (table,columns,data,agency))



def main():
    #Note directory structure: ./gtfs/[agency] contains gtfs files, ./schema contains sql to create schema and build indexes
    thread_list = [1,2,3,4,5,6,7,8]
    db = sys.argv[1]
    hst = sys.argv[2]
    usr = sys.argv[3]
    con = pg.connect(dbname=db,host=hst,user=usr)
    
    agency = sys.argv[4]
    schema = sys.argv[5]
    
    #set up GTFS schema
    try:
      con.query("DROP SCHEMA %s cascade;" % schema)
    except pg.ProgrammingError:
      pass
    con.query("CREATE SCHEMA %s;" % schema)
    os.system('cat ./schema/gtfs_schema.create.sql | psql -U %s -d %s -h %s' % (usr,db,hst))
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
                  if value == '':
                      insert_row.append('NULL')
                  elif not is_numeric(value):
                      insert_row.append("'" + pg.escape_string(value) + "'")
                  else:
                      insert_row.append(value)
              #while threading.activeCount() > 10:
              #    pass
              #thread = queryThread(con,table,','.join(columns),','.join(insert_row),agency)
              #thread.start() 
              insert_into_table(con,table,','.join(columns),','.join(insert_row),agency)
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
    os.system('cat ./schema/gtfs_schema.index.sql | psql -U %s -d %s -h %s' % (usr,db,hst))

if __name__ == '__main__':
    main()