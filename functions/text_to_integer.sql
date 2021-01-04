CREATE OR REPLACE FUNCTION text_to_integer(input_text text)
  RETURNS integer AS
$BODY$
BEGIN
     RETURN replace(input_text, ',', '')::integer;
EXCEPTION WHEN OTHERS THEN
  RETURN null::integer;
END;
$BODY$
  LANGUAGE plpgsql;
