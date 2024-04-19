select  
to_char(created_date, 'YYYY (' ||
to_char(created_date,'MM') || ') Mon') as month_year_created,
engagement_status, count(id) as engagement_count
from public_brm.marketing_leads_v2_dbt
group by to_char(created_date, 'YYYY (' ||
to_char(created_date,'MM') || ') Mon'), engagement_status
LIMIT 100