 SELECT 
    DISTINCT 
    concat_ws('_', mltv2_outer.unhidden_date::DATE,mltv2_outer.dialer_id, mltv2_outer.campaign_id, mltv2_outer.country) AS date_campaign_country
FROM public_brm.marketing_leads mltv2_outer
JOIN public_brm.campaigns ca ON ca.id = mltv2_outer.campaign_id
LEFT JOIN public_brm.marketing_leads ml_created ON 
    CAST(ml_created.created_date AS DATE) = CAST(mltv2_outer.unhidden_date AS DATE)
    AND ml_created.campaign_id = mltv2_outer.campaign_id
LEFT JOIN public_brm.marketing_leads ml_ftd ON 
    CAST(ml_ftd.ftd_date AS DATE) = CAST(mltv2_outer.unhidden_date AS DATE)
    AND ml_ftd.campaign_id = mltv2_outer.campaign_id
WHERE 
    CAST(mltv2_outer.created_date AS DATE) > '2023-02-28' 
    AND ca.cost_type = 'cpa'
    AND CAST(mltv2_outer.unhidden_date AS DATE) > CAST(mltv2_outer.ftd_date AS DATE)
    AND mltv2_outer.is_test IS FALSE
    AND mltv2_outer.hidden IS false
GROUP BY
    mltv2_outer.unhidden_date,
    mltv2_outer.dialer_id,
    mltv2_outer.campaign_id,
    mltv2_outer.country
    HAVING 
    COUNT(DISTINCT ml_created.id) = 0
    AND COUNT(DISTINCT ml_ftd.id) = 0