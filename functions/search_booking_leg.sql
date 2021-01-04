CREATE OR REPLACE FUNCTION search_booking_leg(p_json json)
RETURNS booking_leg_record[]
as 
$func$
DECLARE 
v_search_condition text:=null;
v_rec record;
v_result booking_leg_record[];
v_sql text:=$$SELECT array_agg(single_item)
  FROM
  (SELECT 
row(bl.booking_leg_id, 
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
   )::booking_leg_record  as single_item
FROM booking_leg bl
 $$;
v_where_booking_leg text;
v_where_flight text;
BEGIN
FOR v_rec in	
 (SELECT * FROM json_each_text(p_json) )
 LOOP
  CASE WHEN v_rec.key IN ('departure_airport','arrival_airport' ) THEN
               IF v_where_flight IS NULL 
                THEN v_where_flight := v_rec.key||'='||quote_literal(v_rec.value);
                 ELSE v_where_flight:=v_where_flight ||' AND ' 
                    ||v_rec.key ||'='||quote_literal(v_rec.value);
                 END IF;
       WHEN v_rec.key ='scheduled_departure' THEN
             IF v_where_flight IS NULL 
                THEN v_where_flight := v_rec.key||$$ BETWEEN  $$||
														 quote_literal(v_rec.value)||$$::date
														 AND $$||quote_literal(v_rec.value)||$$::date+1$$;
                 ELSE v_where_flight:=v_where_flight ||' AND ' 
                    ||v_rec.key||$$ BETWEEN  $$|| quote_literal(v_rec.value)||$$::date
												AND $$||quote_literal(v_rec.value)||$$::date+1$$;
                 END IF;
    WHEN v_rec.key = 'flight_id' THEN
            v_where_booking_leg :='bl.flight_id= '|| v_rec.value ;
    ELSE NULL;
  END CASE; 
  END LOOP; 
IF v_where_flight IS NULL THEN 
v_search_condition:=
   $$ WHERE $$||v_where_booking_leg;
 ELSE  v_search_condition:=
$$ JOIN flight f1 ON f1.flight_id=bl.flight_id
   WHERE $$ ||concat_ws(' AND ', 
  v_where_flight, v_where_booking_leg );
   END IF;
v_sql:=v_sql ||v_search_condition||')s';

--raise notice 'sql:%', v_sql;
EXECUTE v_sql INTO v_result;
RETURN (v_result);
END;
$func$ LANGUAGE plpgsql;

