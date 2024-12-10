WITH monthly_data AS (
    -- Aggregate trip counts per month from all_data_trips
    SELECT
        {{ dbt.date_trunc('month', 'pickup_datetime') }} AS trip_month,
        COUNT(*) AS trip_count
    FROM {{ ref('all_data_trips') }}
    GROUP BY {{ dbt.date_trunc('month', 'pickup_datetime') }}
),
cumulative_data AS (
    -- Calculate cumulative trip counts using a window function
    SELECT
        trip_month,
        trip_count,
        SUM(trip_count) OVER (ORDER BY trip_month) AS cumulative_trip_count
    FROM monthly_data
),
all_months AS (
    -- Retrieve all distinct months from the date dimension
    SELECT
        {{ dbt.date_trunc('month', 'date_day') }} AS trip_month
    FROM {{ ref('date_dimension') }}
    GROUP BY {{ dbt.date_trunc('month', 'date_day') }}
)
SELECT
    -- Join all months with the cumulative data to ensure months with no trips are included
    all_months.trip_month,
    COALESCE(cumulative_data.trip_count, 0) AS trip_count,
    COALESCE(cumulative_data.cumulative_trip_count, 0) AS cumulative_trip_count
FROM all_months
LEFT JOIN cumulative_data
    ON all_months.trip_month = cumulative_data.trip_month
ORDER BY trip_month
