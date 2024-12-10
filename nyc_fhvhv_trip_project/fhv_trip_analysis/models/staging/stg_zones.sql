WITH ranked_zones AS (
    SELECT 
        "locationid" AS location_id,
        "zone",
        "the_geom" AS geometry,
        borough,
        shape_area,
        ROW_NUMBER() OVER (
            PARTITION BY "locationid" 
            ORDER BY shape_area DESC
        ) AS row_num
    FROM {{ source('raw', 'taxi_zones') }}
)
SELECT 
    location_id,
    zone,
    geometry,
    borough,
    shape_area
FROM ranked_zones
WHERE row_num = 1
