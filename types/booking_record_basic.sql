CREATE TYPE postgres_air.booking_record_basic AS
(
	booking_id bigint,
	booking_ref text,
	booking_name text,
	account_id integer,
	email text
);
