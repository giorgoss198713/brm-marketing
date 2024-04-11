select ce.id, campaign_id, date,  country, expense, ce.dialer,
concat_ws('_',campaign_id,country,cast(date as date), ce.dialer) as campaign_country_date_dialer
FROM public_brm.campaign_expenses ce
where
expense<>0