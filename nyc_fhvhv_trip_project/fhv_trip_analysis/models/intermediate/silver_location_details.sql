WITH location_data AS (
    SELECT DISTINCT
        "LocationID" AS location_id,
        "Borough" AS borough,
        "Zone" AS zone
    FROM {{ ref('taxi_zone_lookup') }}
),
zones_data AS (
    SELECT DISTINCT
        *
    FROM {{ ref('stg_zones') }}
),
joined_data AS (
    SELECT 
        loc.location_id,
        COALESCE(loc.borough, zone.borough) AS borough,
        COALESCE(loc.zone, zone.zone) AS zone,
        zone.geometry,
        zone.shape_area
    FROM location_data loc
    INNER JOIN zones_data zone
        ON loc.location_id = zone.location_id
)
SELECT 
    location_id,
    borough,
    zone,
    geometry,
    shape_area
FROM joined_data
