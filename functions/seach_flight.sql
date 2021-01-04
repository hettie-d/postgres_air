create or replace function search_flight(p_from_airport text,
p_to_airport text,
p_from_country text,
p_depart_lower timestamptz,
p_depart_upper timestamptz,
p_status text default 'On schedule')
returns setof flight_record as
$body$
begin
return query 
select 
flight_id,
flight_no,
departure_airport::text,
da.airport_name,
arrival_airport::text,
aa.airport_name ,
scheduled_departure,
scheduled_arrival
FROM flight f
 JOIN airport da on da.airport_code=departure_airport
 JOIN airport aa on aa.airport_code=arrival_airport
 WHERE (departure_airport=p_from_airport OR (p_from_airport IS NULL AND
   da.iso_country=p_from_country))
and (p_to_airport is null or arrival_airport=p_to_airport)
and (p_depart_upper is null and scheduled_departure  between p_depart_lower::date
and p_depart_lower::date +1  
or  (actual_departure between  p_depart_lower and
p_depart_upper  
or actual_departure is NULL and scheduled_departure  between p_depart_lower and
p_depart_upper )) 
and status = p_status ;
end;
$body$ language plpgsql;

