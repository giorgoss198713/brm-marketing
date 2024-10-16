WITH status_summary AS (
    SELECT 
        cast(st.created_date as date),
        campaign_id,
        affiliate_name,
        status,
        COUNT(*) AS approved_count,
        (COUNT(*)::decimal / SUM(COUNT(*)) OVER (PARTITION BY cast(st.created_date as date), campaign_id, affiliate_name)) AS ratio,
		concat_ws('_',campaign_id,affiliate_name,cast(st.created_date as date)) as campaign_affiliate_date
    FROM 
        public_brm.sales_transactions_all st
	LEFT JOIN public_brm.marketing_leads_transformed_v2_dbt ml2 ON st.lead_id=ml2.sales_lead_id
	WHERE
		campaign_id IS NOT NULL
		--AND st.created_date>'2024-10-01'
    GROUP BY 
        cast(st.created_date as date), 
        campaign_id, 
        affiliate_name, 
        status
)
SELECT *
FROM status_summary
WHERE status = 'Approved'
ORDER BY 
    created_date, 
    campaign_id, 
    affiliate_name