CREATE TABLE _route_types (
    route_type integer,
    description text
);

CREATE TABLE _routes_to_shapes (
    agency_id character varying,
    route_id character varying,
    shape_id character varying
);


CREATE TABLE _shapes_geom (
    id serial primary key,
    agency_id character varying NOT NULL,
    shape_id character varying,
    the_geom geometry
);

