CREATE OR REPLACE FUNCTION age_category_dyn (p_age text) 
RETURNS text language 'plpgsql' AS
$body$
BEGIN
    RETURN ($$CASE
		WHEN $$||p_age ||$$ <= 2 THEN 'Infant'
		WHEN $$||p_age ||$$<=12 THEN 'Child'
		WHEN $$||p_age ||$$<65 THEN 'Adult'
		ELSE 'Senior' END$$);

END; $body$;