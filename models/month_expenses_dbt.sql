with expense_table as(
select 
to_char("date", 'YYYY (MM) Mon') AS month_year,
campaign_id,
country,
dialer,
sum(expense) as expense,
concat_ws('_',campaign_id,country,to_char("date", 'YYYY (MM) Mon'),dialer) as campaign_country_month_dialer
from public_brm.campaign_expenses_transformed_dbt cet
--where
--campaign_id=2224
--AND country='Uzbekistan'
--AND date>'2024-09-30'
group by to_char("date", 'YYYY (MM) Mon'), campaign_id, country, dialer
),
ftd_table as (
select 
dialer_language, campaign_id, campaign_name, affiliate_id, affiliate_name, country, dialer_id, 
to_char(case when ftd_date is not null then ftd_date else created_date end, 'YYYY (MM) Mon') AS month_year,
sum(case when ftd_date is not null then 1 else 0 end) as ftd_count,
concat_ws('_',campaign_id,country,
to_char(case when ftd_date is not null then ftd_date else created_date end, 'YYYY (MM) Mon'),dialer_id) as campaign_country_month_dialer
from public_brm.marketing_leads_v2_dbt
--where
--dialer_language='EN'
--campaign_id=755
--AND country='Uzbekistan'
--AND cast(case when ftd_date is not null then ftd_date else created_date end as date)>'2024-09-30'
group by dialer_language, campaign_id, campaign_name,  country, dialer_id, affiliate_id, affiliate_name, 
to_char(case when ftd_date is not null then ftd_date else created_date end, 'YYYY (MM) Mon')
)
select 
ft.month_year, ft.dialer_language, ft.country, ft.campaign_id, ft.campaign_name,
ft.affiliate_id, ft.affiliate_name, ft.dialer_id, ftd_count, expense
from ftd_table ft
LEFT JOIN expense_table et ON et.campaign_country_month_dialer=ft.campaign_country_month_dialer
--ORDER BY country

UNION ALL

select
to_char(expense_date, 'YYYY (MM) Mon') AS month_year,
dialer_language,
country,
campaign_id,
campaign_name,
affiliate_id,
affiliate_name,
dialer as dialer_id,
0::bigint as ftd_count,
expense
from public_brm.independent_expenses_dbt
