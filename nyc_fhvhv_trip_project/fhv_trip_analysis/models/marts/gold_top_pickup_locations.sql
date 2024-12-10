WITH pickup_counts AS (
    -- Aggregate trip counts by pickup location
    SELECT
        pickup_borough,
        pickup_zone,
        COUNT(*) AS trip_count
    FROM {{ ref('all_data_trips') }}
    GROUP BY pickup_borough, pickup_zone
),
ranked_pickups AS (
    -- Rank pickup locations by trip count
    SELECT
        pickup_borough,
        pickup_zone,
        trip_count,
        RANK() OVER (ORDER BY trip_count DESC) AS rank
    FROM pickup_counts
)
SELECT
    rank,
    pickup_borough,
    pickup_zone,
    trip_count
FROM ranked_pickups
ORDER BY rank
