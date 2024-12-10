WITH trips AS (
    SELECT 
        trip_id,
        pickup_datetime,
        dropoff_datetime,
        trip_duration_seconds,
        validated_trip_miles,
        pickup_location_id,
        drop_location_id
    FROM {{ ref('trip_dimension') }}
),
dates AS (
    SELECT
        date_key,
        date_day
    FROM {{ ref('date_dimension') }}
),
locations AS (
    SELECT
        location_dim_id,
        location_id,
        borough,
        zone,
        geometry
    FROM {{ ref('location_dimension') }}
)
SELECT
    -- Fact table surrogate key
    {{ dbt_utils.generate_surrogate_key([
        "trips.trip_id",
        "pickup_date.date_key",
        "dropoff_date.date_key"
    ]) }} AS fact_trip_id,

    -- Trip details

    trips.trip_id 
    trips.pickup_datetime,
    trips.dropoff_datetime,
    trips.trip_duration_seconds,
    trips.validated_trip_miles,

    -- Pickup date details
    pickup_date.date_key AS pickup_date_id,
    pickup_date.date_day AS pickup_date,

    -- Dropoff date details
    dropoff_date.date_key AS dropoff_date_id,
    dropoff_date.date_day AS dropoff_date,

    -- Pickup location details
    pickup_location.location_dim_id AS pickup_location_dim_id,
    pickup_location.borough AS pickup_borough,
    pickup_location.zone AS pickup_zone,

    -- Dropoff location details
    dropoff_location.location_dim_id AS dropoff_location_dim_id,
    dropoff_location.borough AS dropoff_borough,
    dropoff_location.zone AS dropoff_zone

FROM trips
-- Join with dates for both pickup and dropoff
LEFT JOIN dates AS pickup_date
    ON DATE(trips.pickup_datetime) = pickup_date.date_day
LEFT JOIN dates AS dropoff_date
    ON DATE(trips.dropoff_datetime) = dropoff_date.date_day
-- Join with locations for both pickup and dropoff
LEFT JOIN locations AS pickup_location
    ON trips.pickup_location_id = pickup_location.location_id
LEFT JOIN locations AS dropoff_location
    ON trips.drop_location_id = dropoff_location.location_id
