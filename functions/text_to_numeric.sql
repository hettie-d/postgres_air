CREATE OR REPLACE FUNCTION text_to_numeric(input_text text)
  RETURNS numeric AS
$BODY$
BEGIN
     RETURN replace(input_text, ',', '')::numeric;
EXCEPTION WHEN OTHERS THEN
  RETURN null::numeric;
END;
$BODY$
  LANGUAGE plpgsql;