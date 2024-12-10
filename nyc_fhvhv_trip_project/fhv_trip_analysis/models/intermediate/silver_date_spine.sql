WITH date_spine AS (
{{ dbt_utils.date_spine(
    datepart="day",
    start_date="cast('2024-01-01' as date)", 
    end_date="current_date at time zone 'America/New_York'"
) }}

)
SELECT 
    CAST(date_day AS date) AS date_day,     -- Base date column
    EXTRACT(YEAR FROM date_day) AS year,    -- Year
    EXTRACT(MONTH FROM date_day) AS month,  -- Month
    EXTRACT(DAY FROM date_day) AS day,      -- Day of the month
    EXTRACT(DOW FROM date_day) AS day_of_week, -- Day of the week (0=Sunday, 6=Saturday)
    CASE 
        WHEN EXTRACT(DOW FROM date_day) IN (0, 6) THEN TRUE
        ELSE FALSE
    END AS is_weekend,                      -- Weekend flag
    EXTRACT(QUARTER FROM date_day) AS quarter, -- Quarter of the year
    EXTRACT(WEEK FROM date_day) AS week_of_year -- Week of the year
FROM date_spine
