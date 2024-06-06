SELECT
DISTINCT 
cet.date as expense_date,
CASE WHEN cet.dialer=24 THEN 'C16'
WHEN cet.dialer=30 THEN 'C17'
WHEN cet.dialer=22 THEN 'C15'
WHEN cet.dialer=7 THEN 'C4'
WHEN cet.dialer=3 THEN 'CB10'
WHEN cet.dialer=5 THEN 'CB9'
WHEN cet.dialer=2 THEN 'C1'
WHEN cet.dialer=17 THEN 'C6'
WHEN cet.dialer=37 THEN 'C2'
WHEN cet.dialer=6 THEN 'C3'
END AS dialer_name,
CASE WHEN dl.language='TR/AZ' THEN 'Invalid'
WHEN dl.language ='RU' AND cm.dialer_campaign_id=539
THEN 'TR/AZ'
WHEN cet.dialer=5 AND cm.dialer_campaign_id=169
THEN 'ITL'
ELSE dl.language END as dialer_language,
cm.dialer_campaign_id,
cet.campaign_id,
cm.affiliate_id,
cet.country, 
cet.dialer,
cm.name as campaign_name,
af.name as affiliate_name,
cet.expense
from public_brm.campaign_expenses_transformed_dbt cet
left join public_brm.campaigns_v2_dbt cm on cm.id = cet.campaign_id
left join public_brm.marketing_leads_v2_dbt ml on CONCAT_WS('_',ml.campaign_id,ml.country,
case when ml.cost_type='cpl' then cast(ml.created_date as date) 
when ml.cost_type='cpa' then (case when cast(ml.created_date as date)>=cast(ml.ftd_date as date) 
							 or 
							 cast(ml.ftd_date as date) is null then cast(ml.created_date as date) else 
			 cast(ml.ftd_date as date) end)end,
ml.dialer_id)= cet.campaign_country_date_dialer
left join public_brm.affiliates af on af.id = cm.affiliate_id
left join public_brm.dialer_languages dl ON dl.id =cet.dialer
where
cet.expense IS NOT NULL
AND cet.dialer IS NOT NULL
AND ml.created_date IS NULL
AND ml.ftd_date IS NULL
