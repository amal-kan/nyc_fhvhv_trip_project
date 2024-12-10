WITH trips AS (
    SELECT
        -- Core trip details
        row_number() OVER () AS unique_row_id, -- Add a unique identifier if one doesn't already exist
        pickup_datetime,
        dropoff_datetime,
        trip_duration_seconds,
        validated_trip_miles,
        
        -- Location IDs
        pickup_location_id,
        drop_location_id
    FROM {{ ref("silver_trip_cleaned") }}
)
SELECT
    -- Generate a surrogate key to uniquely identify each trip
    {{ dbt_utils.generate_surrogate_key([
        "unique_row_id", 
        "pickup_datetime",
        "dropoff_datetime",
        "pickup_location_id",
        "drop_location_id"
    ]) }} AS trip_id,
    -- Retain core trip details
    pickup_datetime,
    dropoff_datetime,
    trip_duration_seconds,
    validated_trip_miles,

    -- Retain location details
    pickup_location_id,
    drop_location_id
FROM trips
