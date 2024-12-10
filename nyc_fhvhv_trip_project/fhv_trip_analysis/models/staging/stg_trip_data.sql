WITH source_data AS (
    SELECT * FROM {{ source('raw', 'fhvhv_tripdata_2024-01') }}
    UNION ALL 
    SELECT * FROM {{ source('raw', 'fhvhv_tripdata_2024-02') }}
    UNION ALL 
    SELECT * FROM {{ source('raw', 'fhvhv_tripdata_2024-03') }}
    UNION ALL 
    SELECT * FROM {{ source('raw', 'fhvhv_tripdata_2024-04') }}
    UNION ALL 
    SELECT * FROM {{ source('raw', 'fhvhv_tripdata_2024-05') }}
    UNION ALL 
    SELECT * FROM {{ source('raw', 'fhvhv_tripdata_2024-06') }}
    UNION ALL 
    SELECT * FROM {{ source('raw', 'fhvhv_tripdata_2024-07') }}
    UNION ALL 
    SELECT * FROM {{ source('raw', 'fhvhv_tripdata_2024-08') }}
    UNION ALL 
    SELECT * FROM {{ source('raw', 'fhvhv_tripdata_2024-09') }}
    
)

SELECT 
    CAST(pickup_datetime AS TIMESTAMP) AS pickup_datetime,
    CAST(dropoff_datetime AS TIMESTAMP) AS dropoff_datetime,
    CAST(trip_miles AS numeric) AS trip_miles,
    trip_time,
    "PULocationID" AS pickup_location_id,
    "DOLocationID" AS drop_location_id
FROM source_data
where pickup_datetime IS NOT NULL AND 
dropoff_datetime IS NOT NULL AND 
trip_miles IS NOT NULL AND 
"PULocationID" IS NOT NULL AND 
"DOLocationID" IS NOT NULL AND 
trip_time IS NOT NULL