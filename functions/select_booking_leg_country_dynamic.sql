create or replace function select_booking_leg_country_dynamic (p_country text,
p_updated timestamptz)
returns setof booking_leg_part
as 
$body$
begin
return query 
execute $$
SELECT departure_airport, booking_id, is_returning
  FROM booking_leg bl
  JOIN flight f USING (flight_id)
  WHERE departure_airport IN 
            (SELECT airport_code
			 FROM airport WHERE iso_country=$$|| quote_literal(p_country) ||
	  $$ AND bl.booking_id IN 
            (SELECT booking_id FROM booking
			WHERE update_ts>$$|| quote_literal(p_updated)||$$)$$;
			end;
			$body$ language plpgsql;
			