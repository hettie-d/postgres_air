CREATE OR REPLACE FUNCTION age_category (p_age int) 
RETURNS TEXT language 'plpgsql' AS
$body$
BEGIN
    RETURN (case
		WHEN p_age <= 25 then 'Infant'
		WHEN p_age <=12 then 'Child'
		WHEN p_age < 65 then 'Adult'
		ELSE 'Senior' END);
END; $body$;