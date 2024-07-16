SELECT DISTINCT
    cet.date as expense_date,
    CASE 
        WHEN cet.dialer = 24 THEN 'C16'
        WHEN cet.dialer = 30 THEN 'C17'
        WHEN cet.dialer = 22 THEN 'C15'
        WHEN cet.dialer = 7 THEN 'C4'
        WHEN cet.dialer = 3 THEN 'CB10'
        WHEN cet.dialer = 5 THEN 'CB9'
        WHEN cet.dialer = 2 THEN 'C1'
        WHEN cet.dialer = 17 THEN 'C6'
        WHEN cet.dialer = 37 THEN 'C2'
        WHEN cet.dialer = 6 THEN 'C3'
    END AS dialer_name,
    CASE 
        WHEN cet.dialer = 37 AND cm.dialer_campaign_id = 539 THEN 'TR/AZ'
		WHEN cet.dialer = 37 AND cm.dialer_campaign_id <> 539 THEN 'RU'
        WHEN cet.dialer = 5 AND cm.dialer_campaign_id = 169 THEN 'ITL'
        WHEN cet.dialer = 5 AND cm.dialer_campaign_id <> 169 THEN 'BR2'
        ELSE dl.dialer_language 
    END as dialer_language,
    cm.dialer_campaign_id,
    cet.campaign_id,
    cm.affiliate_id,
    cet.country, 
    cet.dialer,
    cm.name as campaign_name,
    af.name as affiliate_name,
    cet.expense,
    cm.inhouse_data_live
FROM public_brm.campaign_expenses_transformed_dbt cet
LEFT JOIN public_brm.campaigns_v2_dbt cm ON cm.id = cet.campaign_id
LEFT JOIN public_brm.marketing_leads_v2_dbt ml ON CONCAT_WS('_', ml.campaign_id, ml.country,
    CASE 
        WHEN ml.cost_type = 'cpl' THEN CAST(ml.created_date AS date)
        WHEN ml.cost_type = 'cpa' THEN 
            CASE 
                WHEN CAST(ml.created_date AS date) >= CAST(ml.ftd_date AS date)
                OR CAST(ml.ftd_date AS date) IS NULL THEN CAST(ml.created_date AS date)
                ELSE CAST(ml.ftd_date AS date)
            END
    END,
ml.dialer_id) = cet.campaign_country_date_dialer
LEFT JOIN public_brm.affiliates af ON af.id = cm.affiliate_id
LEFT JOIN public_brm.dialer_languages dl ON dl.id = cet.dialer
WHERE
    cet.expense IS NOT NULL
    AND cet.dialer IS NOT NULL
    AND ml.created_date IS NULL
    AND ml.ftd_date IS NULL