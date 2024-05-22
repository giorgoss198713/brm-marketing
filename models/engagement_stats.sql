with pt_all as (
select to_char(created_date, 'YYYY (' ||
to_char(created_date,'MM') || ') Mon') as month_year_created,
count(id) as engagement_total
from public_brm.marketing_leads_v3_dbt
	group by 1
),
pt_count as (select  
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
dialer_language,
campaign_name,
affiliate_name,
affiliate_id,
invalid_status,
hidden,
is_fake,
inhouse_data_live,
source_id,
engagement_status,
concat_ws('_',to_char(created_date, 'YYYY (' ||
to_char(created_date,'MM') || ') Mon'),dialer_id) as concat,			 
count(id) as engagement_count
from public_brm.marketing_leads_v3_dbt
group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
)

select
pt_count.month_year_created,
pt_count.dialer_id,
pt_count.dialer_name,
pt_count.country,
pt_count.campaign_id,
pt_count.dialer_status,
pt_count.utm_source,
pt_count.utm_medium,
pt_count.dialer_campaign_id,
pt_count.dialer_language,
pt_count.campaign_name,
pt_count.affiliate_name,
pt_count.affiliate_id,
pt_count.invalid_status,
pt_count.hidden,
pt_count.is_fake,
pt_count.inhouse_data_live,
pt_count.source_id,
pt_count.engagement_status,
pt_count.engagement_count,
pt_all.engagement_total,
pt_count.engagement_count*100.00/NULLIF(pt_all.engagement_total,0) as percentage
from pt_count
left join pt_all on pt_all.month_year_created=pt_count.month_year_created
order by pt_count.month_year_created