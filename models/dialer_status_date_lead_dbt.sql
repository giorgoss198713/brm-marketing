WITH jsonb_ml AS (SELECT
    id,
    dialer_name,
	dialer_campaign_id,
    change_log::jsonb
FROM 
    public_brm.change_log_marketing_leads
WHERE 
created_date > CURRENT_DATE - interval '90 days'
),
extract_status AS(
    SELECT 
        id,
        CASE WHEN dialer_name='C17' THEN 'C17 - EN'
        WHEN dialer_name='C2' AND dialer_campaign_id=539 THEN 'C2 - TR/AZ'
        WHEN dialer_name='C2' AND dialer_campaign_id!=539 THEN 'C2 - RU'
        WHEN dialer_name='C4' THEN 'C4 - FR'
        WHEN dialer_name='C6' THEN 'C6 - TH'
        WHEN dialer_name='CB10' THEN 'CB10 - BR1'
        WHEN dialer_name='CB9' AND dialer_campaign_id IN (169,170) THEN 'CB9 - ITL'
        WHEN dialer_name='CB9' AND dialer_campaign_id NOT IN (169,170) THEN 'CB9 - BR2'
        ELSE 'Unknown' END AS dialer_name_language,
        CAST(jsonb_array_elements(change_log) ->> 'updatedDate' AS date) AS updated_date,
        jsonb_array_elements(change_log) -> 'changes' ->> 'dialer_status' AS dialer_status
    FROM 
        jsonb_ml
),
unique_status AS (
    SELECT 
        id,
        updated_date,
        dialer_name_language,
        dialer_status
    FROM 
        extract_status
    WHERE 
        dialer_status IS NOT NULL
    ORDER BY 
        updated_date
),
date_ranges AS (
    SELECT 
        id,
        updated_date AS start_date,
        COALESCE(lead(updated_date, 1) OVER (PARTITION BY id ORDER BY updated_date), CURRENT_DATE + interval '1 day') AS end_date,
        dialer_status,
        dialer_name_language
    FROM 
        unique_status
)
SELECT 
    generate_series(
        start_date, 
        end_date - interval '1 day',
        interval '1 day'
    ) AS date,
    id,
    dialer_status,
    dialer_name_language
FROM 
    date_ranges
ORDER BY 
    id