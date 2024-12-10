SELECT 
    {{ dbt_utils.generate_surrogate_key(["date_day"]) }} AS date_key, 
    date_day,          
    year,              
    month,           
    day,               
    day_of_week,      
    is_weekend,       
    quarter,           
    week_of_year       
FROM {{ ref("silver_date_spine") }}
