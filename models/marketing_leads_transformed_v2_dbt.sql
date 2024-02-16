WITH RECURSIVE
created_cte AS (SELECT id, 1 AS created_count from public_brm.marketing_leads_v2_dbt),
ftd_cte AS (SELECT id, 1 AS ftd_count from public_brm.marketing_leads_v2_dbt WHERE ftd is true),
unhidden_cte AS (SELECT id, 1 AS aff_count from public_brm.marketing_leads_v2_dbt WHERE hidden is false) 
select
ml.id,
ml.campaign_id,
ml.campaign_cost, 
ml.dialer_id,
ml.dialer_name,
cm.affiliate_id,
ml.cost, 
ml.country,
ml.invalid_status,
ml.ftd,
ml.hidden,
ml.is_fake,
ml.created_date,
ml.ftd_date,
ml.unhidden_date,
ml.dialer_campaign_id, 
ml.dialer_comment,
ml.dialer_lead_id, 
ml.dialer_status,
ml.ftd_deposit_amount,
ml.rounded_ftd_deposit_amount,
ml.ftd_bucket,
ml.last_redeposit_date,
ml.redeposit, 
ml.redeposits_amount,
ml.selling_cost,
ml.source_id,
ml.utm_medium,
ml.utm_source,
cm.inhouse_data_live,
cc.created_count,
ft.ftd_count,
un.aff_count,
case when cm.cost_type='cpl' THEN 1 ELSE 0 END cpl_count, 
case when cm.cost_type='cpl' then ft.ftd_count
when cm.cost_type='cpa' then un.aff_count
else 0 end as final_aff_count,
cm.cost_type,
CONCAT_WS('_',ml.campaign_id,ml.country,
CASE WHEN cc.created_count=1 THEN CAST(ml.created_date AS date)
WHEN ft.ftd_count=1 THEN CAST(ml.ftd_date AS date)
WHEN un.aff_count=1 THEN CAST(ml.unhidden_date AS date)
END, ml.dialer_id) as campaign_country_date_dialer,
CONCAT_WS('_',ml.campaign_id,ml.country,
CASE WHEN cc.created_count=1 AND cm.cost_type ='cpl' THEN CAST(ml.created_date AS date)
WHEN cc.created_count=1 AND cm.cost_type ='cpa' AND ft.ftd_count IS NULL THEN CAST(ml.created_date AS date)
WHEN cm.cost_type='cpa' AND ft.ftd_count>0 THEN CAST(ml.ftd_date AS date)
WHEN un.aff_count=1 THEN CAST(ml.unhidden_date AS date)
END, ml.dialer_id, 
CASE WHEN cm.cost_type='cpl' THEN ml.cost
WHEN cm.cost_type='cpa' THEN ml.campaign_cost
END) AS campaign_country_date_dialer_cost,
CONCAT_WS('_',cm.affiliate_id,
CASE WHEN cc.created_count=1 THEN CAST(ml.created_date AS date)
WHEN ft.ftd_count=1 THEN CAST(ml.ftd_date AS date)
WHEN un.aff_count=1 THEN CAST(ml.unhidden_date AS date)
END
) as affiliate_id_date,
cm.name as campaign_name,
af.name as affiliate_name
from public_brm.marketing_leads_v2_dbt ml
left join public_brm.campaigns_v2_dbt cm on ml.campaign_id=cm.id
left join public_brm.affiliates af on cm.affiliate_id =af.id
left join created_cte cc ON cc.id=ml.id
left join ftd_cte ft ON ft.id=ml.id
left join unhidden_cte un ON un.id=ml.id

UNION ALL
SELECT
NULL AS id,
ie.campaign_id, 
NULL AS campaign_cost,
ie.dialer AS dialer_id, 
NULL AS dialer_name,
ie.affiliate_id,
0 AS cost, 
ie.country,
'Valid' AS invalid_status,
NULL AS ftd,
NULL AS hidden,
NULL AS is_fake,
ie.expense_date as created_date,
NULL AS ftd_date,
NULL AS unhidden_date,
NULL AS dialer_campaign_id, 
NULL AS dialer_comment,
NULL AS dialer_lead_id,
'0' AS dialer_status,
NULL AS ftd_deposit_amount,
NULL AS rounded_ftd_deposit_amount,
NULL AS ftd_bucket,
NULL AS last_redeposit_date,
NULL AS redeposit, 
NULL AS redeposits_amount,
NULL AS selling_cost,
NULL AS source_id, 
NULL AS utm_medium,
NULL AS utm_source,
'INHOUSE' AS inhouse_data_live,
NULL AS created_count,
NULL AS ftd_count,
NULL AS aff_count,
NULL AS cpl_count,
NULL AS final_aff_count,
NULL AS cost_type,
concat_ws('_',ie.campaign_id,ie.country, cast(ie.expense_date as date), ie.dialer) AS campaign_country_date_dialer,
concat_ws('_',ie.campaign_id,ie.country, cast(ie.expense_date as date), ie.dialer,0) AS campaign_country_date_dialer_cost,
NULL AS affiliate_id_date,
ie.campaign_name,
ie.affiliate_name
FROM public_brm.independent_expenses_dbt ie
