create or replace function select_booking_dyn (p_email text,
p_dep_airport text,
p_arr_airport text,
p_dep_date date,
p_flight_id int)
returns setof booking_record_basic
as 
$func$
DECLARE 
v_sql text:='SELECT DISTINCT b.booking_id, b.booking_ref, booking_name, account_id, email
FROM  booking b ';
v_where_booking text;
v_where_booking_leg text;
v_where_flight text;
BEGIN
IF p_email IS NOT NULL then v_where_booking :=$$ lower(email) like $$ ||quote_literal(p_email||'%'); END IF;
IF p_flight_id IS NOT NULL then v_where_booking_leg:= $$ flight_id=$$||p_flight_id::text; 
END IF;
IF p_dep_airport IS NOT NULL THEN v_where_flight:=concat_ws($$ AND $$,
													   v_where_flight, 
														$$departure_airport=$$||quote_literal(p_dep_airport));
END IF;														   
IF p_arr_airport IS NOT NULL THEN v_where_flight:=concat_ws($$ AND $$,
													   v_where_flight, 
														$$arrival_airport=$$||quote_literal(p_arr_airport));
END IF;													   
IF p_dep_date IS NOT NULL THEN v_where_flight:=concat_ws($$ AND $$,
													   v_where_flight, 
														$$scheduled_departure BETWEEN $$||
														 quote_literal(p_dep_date)||$$::date
														 AND $$||quote_literal(p_dep_date)||$$::date+1$$);
END IF;		
IF v_where_flight IS NOT NULL OR v_where_booking_leg IS NOT NULL
THEN v_sql:=v_sql||$$ JOIN booking_leg bl USING (booking_id) $$;
END IF;
IF v_where_flight IS NOT NULL THEN 
v_sql:=v_sql ||$$ JOIN flight f USING (flight_id) $$;
END IF;
v_sql:=v_sql ||$$ WHERE $$||
concat_ws($$ AND $$,v_where_booking, v_where_booking_leg, v_where_flight);

raise notice 'sql:%', v_sql;
return query EXECUTE (v_sql);
END;
$func$ LANGUAGE plpgsql;