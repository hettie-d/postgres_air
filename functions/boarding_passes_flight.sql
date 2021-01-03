CREATE OR REPLACE FUNCTION postgres_air.boarding_passes_flight(
	p_flight_id integer)
    RETURNS SETOF postgres_air.boarding_pass_record 
    LANGUAGE 'plpgsql'

AS $BODY$
BEGIN
RETURN QUERY
SELECT pass_id,
bp.booking_leg_id,
flight_no,
departure_airport::text ,
arrival_airport ::text,
last_name ,
first_name ,
seat,
boarding_time
FROM flight f
JOIN booking_leg bl USING (flight_id)	
JOIN boarding_pass bp USING(booking_leg_id)
JOIN passenger USING (passenger_id)
WHERE bl.flight_id=p_flight_id;
END;
$BODY$;