CREATE TYPE postgres_air.booking_leg_record AS
(
	booking_leg_id integer,
	leg_num integer,
	booking_id integer,
	flight postgres_air.flight_record,
	boarding_passes postgres_air.boarding_pass_record[]
);