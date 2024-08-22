WITH jsonb_ml AS (SELECT
    id,
    dialer_name,
	dialer_campaign_id,
    change_log::jsonb
FROM 
    public_brm.change_log_marketing_leads
WHERE 
created_date > CURRENT_DATE - interval '180 days'
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
		jsonb_array_elements(change_log) ->> 'updatedDate' AS updated_date,
        CAST(jsonb_array_elements(change_log) ->> 'updatedDate' AS date) AS updated_day,
        jsonb_array_elements(change_log) -> 'changes' ->> 'dialer_status' AS dialer_status
    FROM 
        jsonb_ml
),
max_within_date AS(
	SELECT 
        id,
		updated_day,
		updated_date,
		dialer_name_language,
		CASE WHEN dialer_status iLIKE '%Call Again - Personal%' THEN 'Call Again - Personal' ELSE dialer_status END AS dialer_status,
        ROW_NUMBER() OVER (PARTITION BY id, updated_date::date ORDER BY updated_date DESC) AS r
    FROM 
        extract_status
		where 
		dialer_status is not null 
		--AND id=2690237
),
unique_status AS (
    SELECT 
        id,
		updated_day,
        dialer_name_language,
        dialer_status
    FROM 
        max_within_date
    WHERE 
		r=1
    ORDER BY 
      updated_day
),
date_ranges AS (
    SELECT 
        id,
        updated_day AS start_date,
        COALESCE(lead(updated_day, 1) OVER (PARTITION BY id ORDER BY updated_day), CURRENT_DATE + interval '1 day') AS end_date,
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