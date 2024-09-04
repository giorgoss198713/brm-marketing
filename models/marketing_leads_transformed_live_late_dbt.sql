WITH RECURSIVE
created_cte AS (SELECT id, 1 AS created_count from public_brm.marketing_leads_v3_dbt),
ftd_cte AS (SELECT id, 1 AS ftd_count from public_brm.marketing_leads_v3_dbt WHERE ftd is true),
unhidden_cte AS (SELECT id, 1 AS aff_count from public_brm.marketing_leads_v3_dbt WHERE hidden is false) 
select
ml.id,
ml.sales_lead_id,
ml.campaign_id,
ml.cost_at_create, 
ml.dialer_id,
ml.dialer_name,
CASE WHEN ml.dialer_name='C17' THEN 'EN'
    WHEN ml.dialer_name='C2' AND ml.dialer_campaign_id=539 THEN 'TR/AZ'
    WHEN ml.dialer_name='C2' AND ml.dialer_campaign_id!=539 THEN 'RU'
    WHEN ml.dialer_name='C4' THEN 'FR'
    WHEN ml.dialer_name='C6' THEN 'TH'
    WHEN ml.dialer_name='CB10' THEN 'BR1'
    WHEN ml.dialer_name='CB9' AND ml.dialer_campaign_id IN (169,170) THEN 'ITL'
    WHEN ml.dialer_name='CB9' AND ml.dialer_campaign_id NOT IN (169,170) THEN 'BR2'
    ELSE 'Unknown' END AS dialer_language,
CASE WHEN ml.dialer_name='C17' THEN 'C17 - EN'
    WHEN ml.dialer_name='C2' AND ml.dialer_campaign_id=539 THEN 'C2 - TR/AZ'
    WHEN ml.dialer_name='C2' AND ml.dialer_campaign_id!=539 THEN 'C2 - RU'
    WHEN ml.dialer_name='C4' THEN 'C4 - FR'
    WHEN ml.dialer_name='C6' THEN 'C6 - TH'
    WHEN ml.dialer_name='CB10' THEN 'CB10 - BR1'
    WHEN ml.dialer_name='CB9' AND ml.dialer_campaign_id IN (169,170) THEN 'CB9 - ITL'
    WHEN ml.dialer_name='CB9' AND ml.dialer_campaign_id NOT IN (169,170) THEN 'CB9 - BR2'
    ELSE 'Unknown' END AS dialer_name_language,
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
ml.ftd_approx,
ml.last_redeposit_date,
ml.redeposit, 
ml.redeposits_amount,
ml.selling_cost,
ml.source_id,
ml.utm_medium,
ml.utm_source,
ml.valid_engage,
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
WHEN cm.cost_type='cpa' THEN ml.cost_at_create
END) AS campaign_country_date_dialer_cost,
CONCAT_WS('_',cm.affiliate_id,
CASE WHEN cc.created_count=1 THEN CAST(ml.created_date AS date)
WHEN ft.ftd_count=1 THEN CAST(ml.ftd_date AS date)
WHEN un.aff_count=1 THEN CAST(ml.unhidden_date AS date)
END
) as affiliate_id_date,
cm.name as campaign_name,
af.name as affiliate_name,
CURRENT_TIMESTAMP AS current_datetime
from public_brm.marketing_leads_v3_dbt ml
left join public_brm.campaigns_v2_dbt cm on ml.campaign_id=cm.id
left join public_brm.affiliates af on cm.affiliate_id =af.id
--left join public_brm.dialer_languages dl ON dl.id =ml.dialer_id
left join created_cte cc ON cc.id=ml.id
left join ftd_cte ft ON ft.id=ml.id
left join unhidden_cte un ON un.id=ml.id