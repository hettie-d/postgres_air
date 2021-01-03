CREATE TABLE boarding_pass_part
(
    boarding_pass_id integer NOT NULL DEFAULT nextval('boarding_pass_part_boarding_pass_id_seq'::regclass),
    passenger_id bigint NOT NULL,
    booking_leg_id bigint NOT NULL,
    seat text,
    boarding_time timestamp with time zone NOT NULL,
    precheck boolean NOT NULL,
    update_ts timestamp with time zone,
    CONSTRAINT boarding_pass_part_pk PRIMARY KEY (boarding_pass_id, boarding_time)
) PARTITION BY RANGE (boarding_time);

ALTER TABLE boarding_pass_part
    OWNER to postgres;


CREATE INDEX boarding_pass_part_booking_leg_id
    ON boarding_pass_part USING btree
    (booking_leg_id ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX boarding_pass_part_passenger_id
    ON boarding_pass_part USING btree
    (passenger_id ASC NULLS LAST)
    TABLESPACE pg_default;


CREATE TABLE boarding_pass_aug PARTITION OF boarding_pass_part
    FOR VALUES FROM ('2020-08-01 00:00:00-05') TO ('2020-09-01 00:00:00-05');


CREATE TABLE boarding_pass_july PARTITION OF boarding_pass_part
    FOR VALUES FROM ('2020-07-01 00:00:00-05') TO ('2020-08-01 00:00:00-05');


CREATE TABLE boarding_pass_june PARTITION OF boarding_pass_part
    FOR VALUES FROM ('2020-06-01 00:00:00-05') TO ('2020-07-01 00:00:00-05');


CREATE TABLE boarding_pass_may PARTITION OF boarding_pass_part
    FOR VALUES FROM ('2020-05-01 00:00:00-05') TO ('2020-06-01 00:00:00-05');
    
INSERT INTO boarding_pass_part SELECT * from boarding_pass;
