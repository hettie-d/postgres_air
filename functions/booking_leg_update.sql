CREATE OR REPLACE FUNCTION booking_leg_update (p_booking_leg_id int,p_object json)
RETURNS SETOF text
AS
$body$
DECLARE
v_result booking_leg_record[];
v_sql text;
v_rec record;
v_flight_id int;
v_flight_each record;
v_booking_leg_update text;
BEGIN
FOR v_rec IN
 (SELECT * FROM json_each_text(p_object) )
 LOOP
  CASE 
  WHEN v_rec.key ='flight'  THEN 
  FOR v_flight_each IN (SELECT * FROM json_each_text(v_rec.value::json))
     LOOP
       CASE 
         WHEN v_flight_each.key='flight_id' THEN  v_flight_id:=v_flight_each.value;
           v_booking_leg_update:=concat_ws(', ', v_booking_leg_update,'flight_id='||quote_literal(v_flight_each.value)) ;
         ELSE NULL;
       END CASE;
     END LOOP; 
  WHEN v_rec.key IN ('leg_num', 'is_returning') 
    THEN   v_booking_leg_update:=concat_ws(', ', v_booking_leg_update,v_rec.key||'='||quote_literal(v_rec.value)) ;
   ELSE NULL;
END  CASE;
END LOOP;
 IF v_booking_leg_update IS NOT NULL THEN
   EXECUTE  ($$UPDATE ¨booking_leg SET $$|| v_booking_leg_update||$$
    WHERE booking_leg_id=$$||p_booking_leg_id::text);
   END IF;
  RETURN QUERY (
   SELECT * FROM array_transport(booking_leg_select_json(p_booking_leg_id)));
   END;
$body$ lANGUAGE plpgsql; 
  
  

