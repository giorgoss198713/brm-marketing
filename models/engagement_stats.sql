select  
to_char(created_date, 'YYYY (' ||
to_char(created_date,'MM') || ') Mon') as month_year_created,
dialer_id,
dialer_name,
country,
campaign_id,
dialer_status,
utm_source,
utm_medium,
dialer_campaign_id,
campaign_name,
affiliate_name,
engagement_status, count(id) as engagement_count
from public_brm.marketing_leads_v3_dbt
group by to_char(created_date, 'YYYY (' ||
to_char(created_date,'MM') || ') Mon'), engagement_status, dialer_id, dialer_name, country, campaign_id, dialer_status, utm_source, 
utm_medium,dialer_campaign_id, campaign_name, affiliate_name
