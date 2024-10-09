select ml.id, sales_lead_id, 
created_date, 
case when hidden is false and is_fake is false and unhidden_date is not null and ftd_date>unhidden_date then unhidden_date
else ftd_date end as ftd_date, 
unhidden_date,
campaign_id, country, dialer_lead_id, dialer_agent,
dialer_error, dialer_calls_count, utm_source, utm_medium, source_id,ftd, ftd_deposit_amount, redeposit, 
redeposits_amount, last_redeposit_date, cost, hidden, selling_cost, 
(case when cm.cost_type='cpl' then NULL ELSE cost_at_create END) AS cost_at_create, 
dialer_id,
dialer_status,
dialer_name,
CASE WHEN dialer_name='C17' THEN 'EN'
    WHEN dialer_name='C2' AND ml.dialer_campaign_id=539 THEN 'TR/AZ'
    WHEN dialer_name='C2' AND ml.dialer_campaign_id!=539 THEN 'RU'
    WHEN dialer_name='C4' THEN 'FR'
    WHEN dialer_name='C7' THEN 'FR'
    WHEN dialer_name='C6' THEN 'TH'
    WHEN dialer_name='CB10' THEN 'BR1'
    WHEN dialer_name='CB9' AND ml.dialer_campaign_id IN (169,170) THEN 'ITL'
    WHEN dialer_name='CB9' AND ml.dialer_campaign_id NOT IN (169,170) THEN 'BR2'
    ELSE 'Unknown' END AS dialer_language,
CASE WHEN dialer_name='C17' THEN 'C17 - EN'
    WHEN dialer_name='C2' AND ml.dialer_campaign_id=539 THEN 'C2 - TR/AZ'
    WHEN dialer_name='C2' AND ml.dialer_campaign_id!=539 THEN 'C2 - RU'
    WHEN dialer_name='C4' THEN 'C4 - FR'
    WHEN dialer_name='C7' THEN 'C7 - FR'
    WHEN dialer_name='C6' THEN 'C6 - TH'
    WHEN dialer_name='CB10' THEN 'CB10 - BR1'
    WHEN dialer_name='CB9' AND ml.dialer_campaign_id IN (169,170) THEN 'CB9 - ITL'
    WHEN dialer_name='CB9' AND ml.dialer_campaign_id NOT IN (169,170) THEN 'CB9 - BR2'
    ELSE 'Unknown' END AS dialer_name_language,
ml.dialer_campaign_id, is_fake,
dialer_comment,
(CASE WHEN (dialer_status iLIKE '%BL MANUAL%'
or dialer_status iLIKE '%Blacklisted Prefix%'
or dialer_status iLIKE '%Institutional%') THEN 'Invalid'
WHEN (dialer_status iLIKE '%New Lead%'
or dialer_status IS NULL) THEN 'Neutral'
WHEN ( dialer_status iLIKE '%Foreign%'
or dialer_status iLIKE '%Invalid Number%'
or dialer_status iLIKE '%Language Barrier%'
or dialer_status iLIKE '%Underage%'
or dialer_status iLIKE '%Wrong Person%') THEN 'Invalid Deal'
ELSE 'Valid' END) as invalid_status,
CASE WHEN (dialer_status iLIKE '%Call Again%'
or dialer_status iLIKE '%HUCC%')
THEN 'Valid Engage'
ELSE 'Not Valid Engage' END as valid_engage,
ROUND(ftd_deposit_amount / 50) * 50 AS rounded_ftd_deposit_amount,
(CASE WHEN ftd_deposit_amount>0 
AND ftd_deposit_amount<100 THEN '01. $1-99'
WHEN ftd_deposit_amount>=100
AND ftd_deposit_amount<150 THEN '02. $100-149'
WHEN ftd_deposit_amount>=150
AND ftd_deposit_amount<200 THEN '03. $150-199'
WHEN ftd_deposit_amount>=200
AND ftd_deposit_amount<300 THEN '04. $200-299'
WHEN ftd_deposit_amount>=300
AND ftd_deposit_amount<400 THEN '05. $300-399'
WHEN ftd_deposit_amount>=400
AND ftd_deposit_amount<500 THEN '06. $400-499'
WHEN ftd_deposit_amount>=500 THEN '07. $500+'
ELSE 'Not an FTD'
END) AS ftd_bucket,
(CASE WHEN  ftd_deposit_amount>0
AND ftd_deposit_amount<200 THEN '100'
WHEN ftd_deposit_amount>=200
AND ftd_deposit_amount<350 THEN '250'
WHEN ftd_deposit_amount>=350
AND ftd_deposit_amount<700 THEN '400'
WHEN ftd_deposit_amount>=700
AND ftd_deposit_amount<900 THEN '800'
WHEN ftd_deposit_amount>=900 THEN '800+'
ELSE NULL
END) AS ftd_approx,
cm.cost_type,
cm.name as campaign_name,
affiliate_id,
aff.name as affiliate_name
from public_brm.marketing_leads ml
left join public_brm.campaigns_v2_dbt cm on ml.campaign_id=cm.id
left join public_brm.affiliates aff on cm.affiliate_id=aff.id
WHERE
is_test is false
AND (created_date>'2023-12-31' OR ftd_date>'2023-12-31' OR unhidden_date>'2023-12-31')
