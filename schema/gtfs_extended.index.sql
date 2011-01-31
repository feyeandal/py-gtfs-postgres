ALTER TABLE ONLY _shapes_geom
    ADD CONSTRAINT set UNIQUE (shape_id, _agency_id);

ALTER TABLE ONLY _shapes_geom
    ADD CONSTRAINT shapes_geom_pkey PRIMARY KEY (gid);


CREATE INDEX shapes_geom_gist ON _shapes_geom USING gist (the_geom);


ALTER TABLE ONLY _shapes_geom
    ADD CONSTRAINT shapes_geom__agency_id_fkey FOREIGN KEY (_agency_id) REFERENCES agency(_agency_id);


