CREATE OR REPLACE FUNCTION booking_leg_insert (p_object json)
RETURNS SETOF text
AS
$body$
DECLARE
v_result booking_leg_record[];
v_sql text;
v_rec record;
v_booking_id int;
v_flight_id int;
v_leg_num int;
v_is_returning boolean;
v_booking_leg_id int;
BEGIN
FOR v_rec IN
 (SELECT * FROM json_each_text(p_object) )
 LOOP
  CASE 
  WHEN v_rec.key ='booking_id' THEN v_booking_id:=v_rec.value;
  WHEN v_rec.key ='flight_id'  THEN v_flight_id:=v_rec.value;
  WHEN v_rec.key ='leg_num'    THEN v_leg_num:=v_rec.value;
  WHEN v_rec.key ='is_returning' THEN v_is_returning:=v_rec.value;
   ELSE NULL;
END  CASE;
END LOOP;
INSERT INTO booking_leg (booking_id, flight_id, leg_num, is_returning, update_ts)
  VALUES (v_booking_id, v_flight_id, v_leg_num, v_is_returning, now())
    RETURNING booking_leg_id into v_booking_leg_id;
 RETURN QUERY (
   SELECT * FROM array_transport(booking_leg_select_json(v_booking_leg_id)));
   END;

$body$ language plpgsql; 
  
  

