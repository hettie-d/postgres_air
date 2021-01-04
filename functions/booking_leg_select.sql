CREATE OR REPLACE FUNCTION postgres_air.booking_leg_select(
	p_booking_leg_id integer)
    RETURNS SETOF postgres_air.booking_leg_record 
    LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
RETURN QUERY
SELECT 
bl.booking_leg_id, 
leg_num,
bl.booking_id,
(SELECT row(flight_id,
flight_no,
departure_airport,
da.airport_name,
arrival_airport,
aa.airport_name ,
scheduled_departure,
scheduled_arrival)::flight_record
FROM flight f
 JOIN airport da on da.airport_code=departure_airport
 JOIN airport aa on aa.airport_code=arrival_airport
 WHERE flight_id=bl.flight_id
 ),
(SELECT array_agg (row(
pass_id,
bp.booking_leg_id,
flight_no,
departure_airport ,
arrival_airport,
last_name ,
first_name ,
seat,
boarding_time)::boarding_pass_record)
FROM flight f1
JOIN  boarding_pass bp ON f1.flight_id=bl.flight_id
	AND bp.booking_leg_id=bl.booking_leg_id
JOIN passenger p ON p.passenger_id=bp.passenger_id)
FROM booking_leg bl
WHERE bl.booking_leg_id=p_booking_leg_id
;
END;
$BODY$;