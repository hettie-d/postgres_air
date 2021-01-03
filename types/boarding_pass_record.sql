CREATE TYPE postgres_air.boarding_pass_record AS
(
	boarding_pass_id integer,
	booking_leg_id bigint,
	flight_no text,
	departure_airport text,
	arrival_airport text,
	last_name text,
	first_name text,
	seat text,
	boarding_time timestamp with time zone
);
