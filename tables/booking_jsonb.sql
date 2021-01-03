/* creates JSONB representation of simplified booking
* type  passenger_record should be created PRIOR to this script run
* see types subdirectory
*/


CREATE TYPE booking_leg_record_2 AS
(booking_leg_id integer,
	leg_num integer,
	booking_id integer,
	flight flight_record);
--create simplified booking type
CREATE TYPE booking_record_2 AS
(     booking_id integer,
	booking_ref text,
	booking_name text,
	email text,
	account_id integer,
	booking_legs booking_leg_record_2[],
	passengers passenger_record[]
);


CREATE TABLE booking_jsonb AS
SELECT  b.booking_id,
to_jsonb ( row (
 b.booking_id,  b.booking_ref,  b.booking_name, b.email, b.account_id,
ls.legs,
ps.passengers
 ) :: booking_record_2 ) as cplx_booking
FROM booking b 
JOIN 
 (SELECT booking_id,    array_agg(row (
booking_leg_id, leg_num, booking_id,
 row(f.flight_id, flight_no, departure_airport, 
 dep.airport_name,
arrival_airport,
arv.airport_name,
 scheduled_departure, scheduled_arrival 
 )::flight_record   
)::booking_leg_record_2)  legs
FROM  booking_leg l
JOIN flight  f   ON  f.flight_id = l.flight_id
JOIN   airport dep  ON dep.airport_code =  f.departure_airport
JOIN   airport arv  ON arv.airport_code =  f.arrival_airport
GROUP BY booking_id)  ls
ON b.booking_id = ls.booking_id
JOIN  
( SELECT    booking_id,
 array_agg(
 row(passenger_id, booking_id, passenger_no, last_name, first_name):: passenger_record)  as passengers
 FROM passenger 
 GROUP by booking_id) ps
 ON ls.booking_id = ps.booking_id
) ;
