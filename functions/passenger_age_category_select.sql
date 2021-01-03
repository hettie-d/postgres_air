/* create type passenger_age_cat_record as(
passenger_id int,
ade_category text
);
*/
create function passenger_age_category_select (p_limit int)
returns setof passenger_age_cat_record
as
$body$
return query
EXECUTE $$SELECT
	passenger_id,
     $$||age_category_dyn('age')||$$ AS age_category
from passenger LIMIT $$p_limit::text$$;
end;
$body$ language plpgsql;