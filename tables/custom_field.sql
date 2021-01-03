create table custom_field (
custom_field_id serial,
passenger_id int,
custom_field_name text,
custom_field_value text);
alter table custom_field
add constraint custom_field_pk primary key (custom_field_id);

do $$
declare v_rec record;
begin
for v_rec in (select passenger_id from passenger)
loop
insert into custom_field (passenger_id, 
						 custom_field_name,
                          custom_field_value)
						  values
						  (v_rec.passenger_id,
						  'passport_num',
						  ((random()*1000000000000)::bigint)::text);
end loop;
end;
$$;



do $$
declare v_rec record;
v_days int;
begin
for v_rec in (select passenger_id from passenger)
loop
v_days:=(random()*5000)::int;
insert into custom_field (passenger_id, 
						 custom_field_name,
                          custom_field_value)
						  values
						  (v_rec.passenger_id,
						  'passport_exp_date',
						  (('2020-08-18'::date + v_days*interval '1 day')::date)::text);
end loop;
end;
$$;

do $$
declare v_rec record;
v_country text;
begin
for v_rec in (select passenger_id from passenger)
loop
v_country:=case mod (v_rec.passenger_id, 7)
when 0 then 'Mordor'
when 1 then 'Narnia'
When 2 then 'Shambhala'
when 3 then 'Shire'
when 4 then 'Narnia'
when 5 then 'Shire'
when 6 then 'Narnia'
end ;

insert into custom_field (passenger_id, 
						 custom_field_name,
                          custom_field_value)
						  values
						  (v_rec.passenger_id,
						  'passport_country',
						  v_country);
end loop;
end;
$$;



