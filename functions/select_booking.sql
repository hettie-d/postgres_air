CREATE OR REPLACE FUNCTION select_booking(
	p_email text,
	p_dep_airport text,
	p_arr_airport text,
	p_dep_date date,
	p_flight_id integer)
    RETURNS SETOF postgres_air.booking_record_basic 
    LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
return query 
 select  distinct b.booking_id, b.booking_ref, booking_name, account_id, email
from booking b
join 
 booking_leg bl using (booking_id)
join flight f using (flight_id)
where (p_email is null or lower(email) like p_email||'%')
AND (p_dep_airport IS NULL or departure_airport=p_dep_airport)
AND (p_arr_airport IS NULL or arrival_airport=p_arr_airport)
AND (p_flight_id IS NULL OR bl.flight_id=p_flight_id)
AND (p_dep_date IS NULL OR scheduled_departure BETWEEN p_dep_date and p_dep_date+1);
end;
$BODY$;