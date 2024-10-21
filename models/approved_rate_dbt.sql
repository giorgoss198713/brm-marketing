WITH status_summary AS (
    SELECT 
        cast(st.created_date as date),
        campaign_id,
        campaign_name,
        country,
        status,
        COUNT(*) AS status_count,
        (COUNT(*)::decimal / SUM(COUNT(*)) OVER (PARTITION BY cast(st.created_date as date), campaign_id, campaign_name, country)) AS ratio,
		concat_ws('_',campaign_id,campaign_name,country,cast(st.created_date as date)) as campaign_country_date
    FROM 
        public_brm.sales_transactions_all st
	LEFT JOIN public_brm.marketing_leads_transformed_v2_dbt ml2 ON st.lead_id=ml2.sales_lead_id
	WHERE
	campaign_id IS NOT NULL
    GROUP BY 
        cast(st.created_date as date), 
        campaign_id, 
        campaign_name,
        country,
        status
),
totals AS (
    SELECT 
        created_date,
        campaign_id,
        campaign_name,
        country,
        SUM(status_count) AS total_count,
        SUM(CASE WHEN status = 'Approved' THEN status_count ELSE 0 END) AS approved_count,
		campaign_country_date
    FROM 
        status_summary
    GROUP BY 
        created_date, 
        campaign_name,
        campaign_id,
        country,
		campaign_country_date
)
SELECT 
    t.created_date,
    t.campaign_id,
    t.campaign_name,
    t.country,
    t.approved_count,
    -- Count of Other Statuses
    t.total_count - t.approved_count AS other_statuses_count,
    -- Ratio of Approved Status
    (t.approved_count::decimal / t.total_count) AS approved_ratio,
    -- Ratio of All Other Statuses
    ((t.total_count - t.approved_count)::decimal / t.total_count) AS other_statuses_ratio,
	campaign_country_date
FROM 
    totals t
ORDER BY 
    t.created_date, 
    t.campaign_id, 
    t.campaign_name,
    t.country
