CREATE MATERIALIZED VIEW passenger_passport
AS
 SELECT cf.passenger_id,
    COALESCE(max(
        CASE
            WHEN (cf.custom_field_name = 'passport_num'::text) THEN cf.custom_field_value
            ELSE NULL::text
        END), ''::text) AS passport_num,
    COALESCE(max(
        CASE
            WHEN (cf.custom_field_name = 'passport_exp_date'::text) THEN cf.custom_field_value
            ELSE NULL::text
        END), ''::text) AS passport_exp_date,
    COALESCE(max(
        CASE
            WHEN (cf.custom_field_name = 'passport_country'::text) THEN cf.custom_field_value
            ELSE NULL::text
        END), ''::text) AS passport_country
   FROM postgres_air_large.custom_field cf
  GROUP BY cf.passenger_id