create  or replace function num_passengers(p_flight_id int) returns integer
as
$$
begin
return (
	select count(*) from booking_leg bl
		join booking b using (booking_id)
		join passenger p
		using (booking_id)
where flight_id=p_flight_id);
end;
$$ language plpgsql;

create  or replace function num_passengers(p_airport_code text, p_departure date) returns integer
as
$$
begin
return (
	 select count(*) from booking_leg bl
		join booking b using (booking_id)
		join passenger p
		using (booking_id)
	    join flight f using (flight_id)
where departure_airport=p_airport_code
and scheduled_departure between p_departure and p_departure +1);
end;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION postgres_air.num_passengers(
	p_flight_id integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
AS $BODY$
begin
return (select count(*) from booking_leg bl
		join booking b using (booking_id)
		join passenger p
		using (booking_id)
where flight_id=p_flight_id);
end;
$BODY$;
