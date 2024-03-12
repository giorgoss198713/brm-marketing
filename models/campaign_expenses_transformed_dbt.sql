select id, campaign_id, date,  country, expense, dialer,
concat_ws('_',campaign_id,country,cast(date as date), dialer) as campaign_country_date_dialer
FROM public_brm.campaign_expenses
where
expense<>0