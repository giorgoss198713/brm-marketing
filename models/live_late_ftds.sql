with
live_ftd AS (SELECT id, 1 AS live_ftd_count from public_brm.marketing_leads_v3_dbt
WHERE cast(ftd_date as date)=cast(created_date as date)),
ftd_cte AS (SELECT id, 1 AS ftd_count from public_brm.marketing_leads_v3_dbt
WHERE ftd is true)
select to_char(ftd_date, 'YYYY (' ||
to_char(ftd_date,'MM') || ') Mon') as month_year_ftd, 
dialer_name,
dialer_language,
dialer_name_language,
campaign_id,
campaign_name,
affiliate_id,
affiliate_name,
source_id,
valid_engage,
utm_source,
utm_medium,
inhouse_data_live,
country,
concat_ws('_',dialer_name,country) as dialer_country,
coalesce(sum(live_ftd_count),0) as live_ftds,
(coalesce(sum(ftd.ftd_count),0)-coalesce(sum(live_ftd_count),0)) as late_ftds,
coalesce(sum(ftd.ftd_count),0) as total_ftds
from public_brm.marketing_leads_transformed_live_late_dbt mlt2
left join live_ftd lf ON lf.id=mlt2.id
left join ftd_cte ftd ON ftd.id=mlt2.id
where
ftd_date IS NOT NULL
GROUP BY  to_char(ftd_date, 'YYYY (' ||
to_char(ftd_date,'MM') || ') Mon'), country, dialer_name, dialer_language, dialer_name_language, 
campaign_id, campaign_name, affiliate_id, affiliate_name, source_id, valid_engage, inhouse_data_live,
utm_source,
utm_medium