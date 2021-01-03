CREATE TYPE postgres_air.booking_leg_part AS
(
	departure_airport character(3),
	booking_id integer,
	is_returning boolean
);