

ALTER TABLE ONLY agency
    ADD CONSTRAINT agency_pkey PRIMARY KEY (_agency_id);

ALTER TABLE ONLY calendar
    ADD CONSTRAINT calendar_pkey PRIMARY KEY (_agency_id, service_id);

ALTER TABLE ONLY fare_attributes
    ADD CONSTRAINT fare_attributes_pkey PRIMARY KEY (_agency_id, fare_id);

ALTER TABLE ONLY routes
    ADD CONSTRAINT routes_pkey PRIMARY KEY (_agency_id, route_id);


ALTER TABLE ONLY stops
    ADD CONSTRAINT unique_agency_stop UNIQUE (_agency_id, stop_id);


ALTER TABLE ONLY trips
    ADD CONSTRAINT trips_pkey PRIMARY KEY (_agency_id, trip_id);


ALTER TABLE ONLY calendar
    ADD CONSTRAINT calendar__agency_id_fkey FOREIGN KEY (_agency_id) REFERENCES agency(_agency_id);


ALTER TABLE ONLY calendar_dates
    ADD CONSTRAINT calendar_dates__agency_id_fkey FOREIGN KEY (_agency_id, service_id) REFERENCES calendar(_agency_id, service_id);

ALTER TABLE ONLY fare_attributes
    ADD CONSTRAINT fare_attributes__agency_id_fkey FOREIGN KEY (_agency_id) REFERENCES agency(_agency_id);

ALTER TABLE ONLY fare_rules
    ADD CONSTRAINT fare_rules__agency_id_fkey FOREIGN KEY (_agency_id, fare_id) REFERENCES fare_attributes(_agency_id, fare_id);

ALTER TABLE ONLY frequencies
    ADD CONSTRAINT frequencies__agency_id_fkey FOREIGN KEY (_agency_id, trip_id) REFERENCES trips(_agency_id, trip_id);

ALTER TABLE ONLY routes
    ADD CONSTRAINT routes__agency_id_fkey FOREIGN KEY (_agency_id) REFERENCES agency(_agency_id);


ALTER TABLE ONLY shapes
    ADD CONSTRAINT shapes__agency_id_fkey FOREIGN KEY (_agency_id) REFERENCES agency(_agency_id);


ALTER TABLE ONLY stop_times
    ADD CONSTRAINT stop_times__agency_id_fkey FOREIGN KEY (_agency_id, trip_id) REFERENCES trips(_agency_id, trip_id);

ALTER TABLE ONLY stop_times
    ADD CONSTRAINT stop_times__agency_id_fkey1 FOREIGN KEY (_agency_id, stop_id) REFERENCES stops(_agency_id, stop_id);

ALTER TABLE ONLY stops
    ADD CONSTRAINT stops__agency_id_fkey FOREIGN KEY (_agency_id) REFERENCES agency(_agency_id);

ALTER TABLE ONLY trips
    ADD CONSTRAINT trips__agency_id_fkey FOREIGN KEY (_agency_id, route_id) REFERENCES routes(_agency_id, route_id);

ALTER TABLE ONLY trips
    ADD CONSTRAINT trips__agency_id_fkey1 FOREIGN KEY (_agency_id, service_id) REFERENCES calendar(_agency_id, service_id);