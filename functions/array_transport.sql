create or replace
function array_transport (all_items  anyarray) returns setof text
 returns null on null input
language plpgsql   as
$body$
declare
  item  record;
begin
foreach   item  in array all_items
loop
   return next(to_json(item)::text);
   end loop;
end;
$body$;