{{ config(materialized='table') }}

{{config (schema = 'MART')}} --TO CREATE MART SCHEMA AND TABLE WILL BE CREATE INSIDE THIS MART
WITH staging AS (

    SELECT
        ica024,
        callsign,
        country,
        latitude,
        longitude,
        baro_altitude,
        velocity,
        true_track,
        position_timestamp
    FROM {{ ref('stg_opensky_states') }}

)

SELECT
    ica024 AS aircraft_id,
    TRIM(callsign) AS callsign,
    country,
    latitude,
    longitude,
    baro_altitude AS altitude,
    velocity AS speed,
    true_track AS heading,
    position_timestamp,
CASE 
    WHEN baro_altitude IS NULL OR baro_altitude <= 0 THEN NULL
    ELSE baro_altitude * 3.28084  --Meter to ft conversion
END AS altitude_ft
FROM staging