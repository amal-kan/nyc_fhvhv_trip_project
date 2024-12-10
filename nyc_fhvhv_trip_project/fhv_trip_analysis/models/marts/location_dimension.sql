SELECT
    {{ dbt_utils.generate_surrogate_key(["location_id"]) }} As location_dim_id,
 -- Surrogate key
    location_id,           
    borough, 
    zone,           
    shape_area,           
    geometry              
FROM {{ ref("silver_location_details") }}
