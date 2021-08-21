CREATE TYPE postgres_air.flight_record AS
( 
	flight_id int,
	flight_no text,
	departure_airport_code text,
	departure_airport_name text,
	arrival_airport_code text,
	arrival_airport_name text,
	scheduled_departure timestamp with time zone,
	scheduled_arrival timestamp with time zone
);
