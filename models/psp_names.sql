select DISTINCT psp_name from public_brm.sales_transactions_all sta
LEFT JOIN public_brm.marketing_leads ml ON ml.sales_lead_id=sta.lead_id
where
sta.created_date>'2024-01-01'
AND ml.country is not null
ORDER BY psp_name