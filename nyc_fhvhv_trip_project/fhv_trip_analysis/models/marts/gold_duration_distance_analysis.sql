WITH time_of_day_data AS (
    SELECT
        CASE
            WHEN EXTRACT(HOUR FROM pickup_datetime) BETWEEN 0 AND 5 THEN 'Night'
            WHEN EXTRACT(HOUR FROM pickup_datetime) BETWEEN 6 AND 11 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM pickup_datetime) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS time_of_day,
        trip_duration_seconds,
        validated_trip_miles
    FROM {{ ref('all_data_trips') }}
),
aggregated_data AS (
    SELECT
        time_of_day,
        -- Use AVG() on numeric columns directly
        ROUND(AVG(trip_duration_seconds) OVER (PARTITION BY time_of_day), 2) AS avg_trip_duration,
        ROUND(AVG(validated_trip_miles) OVER (PARTITION BY time_of_day), 2) AS avg_trip_distance
    FROM time_of_day_data
)
SELECT
    time_of_day,
    MAX(avg_trip_duration) AS avg_trip_duration,
    MAX(avg_trip_distance) AS avg_trip_distance
FROM aggregated_data
GROUP BY time_of_day
ORDER BY
    CASE
        WHEN time_of_day = 'Morning' THEN 1
        WHEN time_of_day = 'Afternoon' THEN 2
        WHEN time_of_day = 'Evening' THEN 3
        WHEN time_of_day = 'Night' THEN 4
        ELSE 5
    END
