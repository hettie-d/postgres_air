CREATE OR REPLACE VIEW flight_departure
 AS
 SELECT bl.flight_id,
    f.departure_airport,
    (COALESCE(f.actual_departure, f.scheduled_departure))::date AS departure_date,
    count(DISTINCT p.passenger_id) AS num_passengers
   FROM (((postgres_air.booking b
     JOIN postgres_air.booking_leg bl USING (booking_id))
     JOIN postgres_air.flight f USING (flight_id))
     JOIN postgres_air.passenger p USING (booking_id))
  GROUP BY bl.flight_id, f.departure_airport, ((COALESCE(f.actual_departure, f.scheduled_departure))::date);
