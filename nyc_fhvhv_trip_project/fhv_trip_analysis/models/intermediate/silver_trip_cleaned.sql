WITH bronze_data AS (
    SELECT
        pickup_datetime,
        dropoff_datetime,
        trip_time,
        trip_miles,
        pickup_location_id,
        drop_location_id 
    FROM {{ ref('stg_trip_data') }}
),
validated_data AS (
    SELECT
        pickup_datetime,
        dropoff_datetime,
        -- Calculate trip duration in seconds
        CASE
            WHEN trip_time IS NOT NULL AND trip_time > 0 AND trip_time <= 86400 THEN trip_time -- range to be validated with business
            WHEN pickup_datetime IS NOT NULL AND dropoff_datetime IS NOT NULL 
                 AND dropoff_datetime >= pickup_datetime THEN
                 EXTRACT(EPOCH FROM (dropoff_datetime - pickup_datetime))
            ELSE NULL
        END AS trip_duration_seconds,
        -- Validate trip miles
        CASE
            WHEN trip_miles IS NOT NULL AND trip_miles >= 0.1 AND trip_miles <= 500 THEN trip_miles -- range to be validated with business
            ELSE NULL
        END AS validated_trip_miles,
        pickup_location_id,
        drop_location_id
    FROM bronze_data
)
SELECT
    pickup_datetime,
    dropoff_datetime,
    trip_duration_seconds,
    validated_trip_miles,
    pickup_location_id,
    drop_location_id
FROM validated_data
WHERE trip_duration_seconds IS NOT NULL
  AND validated_trip_miles IS NOT NULL
