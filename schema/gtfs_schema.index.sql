

ALTER TABLE ONLY agency
    ADD CONSTRAINT agency_pkey PRIMARY KEY (agency_id);

ALTER TABLE ONLY calendar
    ADD CONSTRAINT calendar_pkey PRIMARY KEY (agency_id, service_id);

ALTER TABLE ONLY fare_attributes
    ADD CONSTRAINT fare_attributes_pkey PRIMARY KEY (agency_id, fare_id);

ALTER TABLE ONLY routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (agency_id, route_id);


ALTER TABLE ONLY stops
    ADD CONSTRAINT unique_agency_stop UNIQUE (agency_id, stop_id);


ALTER TABLE ONLY trips
    ADD CONSTRAINT trips_pkey PRIMARY KEY (agency_id, trip_id);


ALTER TABLE ONLY calendar
    ADD CONSTRAINT calendar_agency_id_fkey FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


ALTER TABLE ONLY calendar_dates
    ADD CONSTRAINT calendar_dates_agency_id_fkey FOREIGN KEY (agency_id, service_id) REFERENCES calendar(agency_id, service_id);

ALTER TABLE ONLY fare_attributes
    ADD CONSTRAINT fare_attributes_agency_id_fkey FOREIGN KEY (agency_id) REFERENCES agency(agency_id);

ALTER TABLE ONLY fare_rules
    ADD CONSTRAINT fare_rules_agency_id_fkey FOREIGN KEY (agency_id, fare_id) REFERENCES fare_attributes(agency_id, fare_id);

ALTER TABLE ONLY frequencies
    ADD CONSTRAINT frequencies_agency_id_fkey FOREIGN KEY (agency_id, trip_id) REFERENCES trips(agency_id, trip_id);

ALTER TABLE ONLY routes
    ADD CONSTRAINT routes_agency_id_fkey FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


ALTER TABLE ONLY shapes
    ADD CONSTRAINT shapes_agency_id_fkey FOREIGN KEY (agency_id) REFERENCES agency(agency_id);


ALTER TABLE ONLY stop_times
    ADD CONSTRAINT stop_times_agency_id_fkey FOREIGN KEY (agency_id, trip_id) REFERENCES trips(agency_id, trip_id);

ALTER TABLE ONLY stop_times
    ADD CONSTRAINT stop_times_agency_id_fkey1 FOREIGN KEY (agency_id, stop_id) REFERENCES stops(agency_id, stop_id);

ALTER TABLE ONLY stops
    ADD CONSTRAINT stops_agency_id_fkey FOREIGN KEY (agency_id) REFERENCES agency(agency_id);

ALTER TABLE ONLY trips
    ADD CONSTRAINT trips_agency_id_fkey FOREIGN KEY (agency_id, route_id) REFERENCES routes(agency_id, route_id);

ALTER TABLE ONLY trips
    ADD CONSTRAINT trips_agency_id_fkey1 FOREIGN KEY (agency_id, service_id) REFERENCES calendar(agency_id, service_id);