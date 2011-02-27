--metadata

CREATE TABLE route_types (route_type int primary key, description varchar);

INSERT INTO route_types VALUES (0,'streetcar/light rail');
INSERT INTO route_types VALUES (1,'subway/metro');
INSERT INTO route_types VALUES (2,'rail');
INSERT INTO route_types VALUES (3,'bus');
INSERT INTO route_types VALUES (4,'ferry');
INSERT INTO route_types VALUES (5,'cable car');
INSERT INTO route_types VALUES (6,'gondola');
INSERT INTO route_types VALUES (7,'funicular');


CREATE TABLE agency (
    _agency_id character varying NOT NULL,
    agency_id character varying,
    agency_name character varying NOT NULL,
    agency_url character varying NOT NULL,
    agency_timezone character varying NOT NULL,
    agency_lang character varying,
    agency_phone character varying,
    agency_fare_url character varying
);

CREATE TABLE calendar (
    _agency_id character varying NOT NULL,
    service_id character varying NOT NULL,
    monday integer NOT NULL,
    tuesday integer NOT NULL,
    wednesday integer NOT NULL,
    thursday integer NOT NULL,
    friday integer NOT NULL,
    saturday integer NOT NULL,
    sunday integer NOT NULL,
    start_date character varying NOT NULL,
    end_date character varying NOT NULL
);

CREATE TABLE calendar_dates (
    _agency_id character varying,
    service_id character varying NOT NULL,
    date character varying NOT NULL,
    exception_type character varying NOT NULL
);


CREATE TABLE fare_attributes (
    _agency_id character varying NOT NULL,
    fare_id character varying NOT NULL,
    price character varying NOT NULL,
    currency_type character varying NOT NULL,
    payment_method integer NOT NULL,
    transfers integer,
    transfer_duration integer
);

CREATE TABLE fare_rules (
    _agency_id character varying NOT NULL,
    fare_id character varying NOT NULL,
    route_id character varying,
    origin_id character varying,
    destination_id character varying,
    contains_id character varying
);

CREATE TABLE frequencies (
    _agency_id character varying NOT NULL,
    trip_id character varying NOT NULL,
    start_time character varying NOT NULL,
    end_time character varying NOT NULL,
    headway_secs integer NOT NULL
);


CREATE TABLE routes (
    _agency_id character varying NOT NULL,
    agency_id character varying,
    route_id character varying NOT NULL,
    route_short_name character varying,
    route_long_name character varying NOT NULL,
    route_desc character varying,
    route_type integer NOT NULL,
    route_url character varying,
    route_color character varying,
    route_text_color character varying
);

CREATE TABLE shapes (
    _agency_id character varying NOT NULL,
    shape_id character varying NOT NULL,
    shape_pt_lat double precision NOT NULL,
    shape_pt_lon double precision NOT NULL,
    shape_pt_sequence integer NOT NULL,
    shape_dist_traveled double precision,
    the_geom geometry
);

CREATE TABLE stop_times (
    _agency_id character varying NOT NULL,
    trip_id character varying NOT NULL,
    arrival_time character varying NOT NULL,
    departure_time character varying NOT NULL,
    stop_id character varying NOT NULL,
    stop_sequence integer NOT NULL,
    stop_headsign character varying,
    pickup_type integer,
    drop_off_type integer,
    shape_dist_traveled integer
);

CREATE TABLE stops (
    _agency_id character varying NOT NULL,
    stop_id character varying NOT NULL,
    stop_code character varying,
    stop_name character varying NOT NULL,
    stop_desc character varying,
    stop_lat double precision NOT NULL,
    stop_lon double precision NOT NULL,
    zone_id character varying,
    stop_url character varying,
    location_type integer,
    parent_station character varying,
    --custom field for CTA
    wheelchair_boarding varchar,
    the_geom geometry
);


CREATE TABLE trips (
    _agency_id character varying NOT NULL,
    route_id character varying NOT NULL,
    service_id character varying NOT NULL,
    trip_id character varying NOT NULL,
    trip_headsign character varying,
    trip_short_name character varying,
    direction_id integer,
    block_id character varying,
    shape_id character varying,
    --custom for CTA
    wheelchair_accessible varchar,
    direction varchar
);