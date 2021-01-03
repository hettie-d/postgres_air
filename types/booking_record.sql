CREATE TYPE postgres_air.booking_record AS
(
	booking_id integer,
	booking_ref text,
	booking_name text,
	email text,
	account_id integer,
	passengers postgres_air.passenger_record[]
);