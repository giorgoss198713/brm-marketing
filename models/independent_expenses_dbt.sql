SELECT
DISTINCT 
cet.date as expense_date, 
cet.campaign_id,
cm.affiliate_id,
cet.country, 
cet.dialer,
cm.name as campaign_name,
af.name as affiliate_name,
cet.expense
from public_brm.campaign_expenses_transformed_dbt cet
left join public_brm.marketing_leads_v2_dbt ml on CONCAT_WS('_',ml.campaign_id,ml.country,
case when cast(ml.created_date as date)>=cast(ml.ftd_date as date) or cast(ml.ftd_date as date) is null then cast(ml.created_date as date) else 
			 cast(ml.ftd_date as date) end,
ml.dialer_id)= cet.campaign_country_date_dialer
left join public_brm.campaigns_v2_dbt cm on cm.id = cet.campaign_id
left join public_brm.affiliates af on af.id = cm.affiliate_id
where
cet.expense IS NOT NULL
AND cet.dialer IS NOT NULL
AND ml.created_date IS NULL
AND ml.ftd_date IS NULL