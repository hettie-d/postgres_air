CREATE MATERIALIZED VIEW flight_departure_mv
AS
 SELECT bl.flight_id,
    f.departure_airport,
    (COALESCE(f.actual_departure, f.scheduled_departure))::date AS departure_date,
    count(DISTINCT p.passenger_id) AS num_passengers
   FROM (((postgres_air.booking b
     JOIN postgres_air.booking_leg bl USING (booking_id))
     JOIN postgres_air.flight f USING (flight_id))
     JOIN postgres_air.passenger p USING (booking_id))
  GROUP BY bl.flight_id, f.departure_airport, ((COALESCE(f.actual_departure, f.scheduled_departure))::date)
;

CREATE INDEX flight_departure_dep_airport
    ON flight_departure_mv 
    (departure_airport);
CREATE INDEX flight_departure_dep_dateUSING btree
    (departure_date);
CREATE UNIQUE INDEX flight_departure_flight_id
    ON flight_departure_mv 
    (flight_id);