WITH RECURSIVE
ftd_cte AS (SELECT cast(ml.ftd_date as date) as ftd_day, ml.campaign_id,
ml.country, concat_ws('_',cast(ml.ftd_date as date), ml.dialer_id, ml.campaign_id, ml.country) as date_campaign_country, 
count(ml.id) as ftd_count from public_brm.marketing_leads_v2_dbt ml where ml.ftd is true group by cast(ml.ftd_date as date), 
ml.dialer_id, ml.campaign_id, ml.country),
total_cte AS (SELECT DISTINCT ml.dialer_id, ml.country, ml.campaign_id, cm.affiliate_id, ml.dialer_campaign_id,
case when cm.cost_type='cpl' then cast(ml.created_date as date)
when cm.cost_type='cpa' and un.date_campaign_country is not null then cast(ml.unhidden_date as date)
when cm.cost_type='cpa' and cast(ml.unhidden_date as date)>cast(ml.created_date as date) and cast(ml.ftd_date as date) is null then cast(ml.unhidden_date as date)
when cm.cost_type='cpa' and cast(ml.ftd_date as date) is null then cast(ml.created_date as date)
when cm.cost_type='cpa' and cast(ml.ftd_date as date)>cast(ml.created_date as date) then cast(ml.ftd_date as date) 
else cast(ml.created_date as date) end as date,
cet.expense,
CONCAT_WS('_',ml.campaign_id,
ml.country,case when cm.cost_type='cpl' then cast(ml.created_date as date)
when cm.cost_type='cpa' and un.date_campaign_country is not null then cast(ml.unhidden_date as date)
when cm.cost_type='cpa' and cast(ml.unhidden_date as date)>cast(ml.created_date as date) and cast(ml.ftd_date as date) is null then cast(ml.unhidden_date as date)
when cm.cost_type='cpa' and cast(ml.ftd_date as date) is null then cast(ml.created_date as date)
when cm.cost_type='cpa' and cast(ml.ftd_date as date)>cast(ml.created_date as date) then cast(ml.ftd_date as date) 
else cast(ml.created_date as date)  end
, ml.dialer_id) as campaign_country_date_dialer,
case when cm.cost_type='cpl' and ml.cost=0 then cet.expense
when cm.cost_type='cpl' and ml.cost<>0 then ml.cost*sum(1)
when cm.cost_type='cpa' then ft.ftd_count*ml.cost_at_create
end as actual_cost,
CONCAT_WS('_',ml.campaign_id,
ml.country,case when cm.cost_type='cpl' then cast(ml.created_date as date)
when cm.cost_type='cpa' and un.date_campaign_country is not null then cast(ml.unhidden_date as date)
when cm.cost_type='cpa' and cast(ml.unhidden_date as date)>cast(ml.created_date as date) and cast(ml.ftd_date as date) is null then cast(ml.unhidden_date as date)
when cm.cost_type='cpa' and cast(ml.ftd_date as date) is null then cast(ml.created_date as date)
when cm.cost_type='cpa' and cast(ml.ftd_date as date)>cast(ml.created_date as date) then cast(ml.ftd_date as date) 
else cast(ml.created_date as date)  end 
, ml.dialer_id,
case when cm.cost_type='cpl' and ml.cost=0 THEN 0 
when cm.cost_type='cpa' THEN ml.cost_At_create
else ml.cost end) as campaign_country_date_dialer_cost,
case 
when cm.cost_type='cpl' and ml.cost=0
then cet.expense/sum(1)
when cm.cost_type='cpl' and ml.cost<>0
then ml.cost
when cm.cost_type='cpa'
then ml.cost_at_create
else null end AS individual_cost
from public_brm.marketing_leads_v2_dbt ml
left join public_brm.campaigns_v2_dbt cm on ml.campaign_id=cm.id
left join public_brm.unhidden_noleads_dbt un ON un.date_campaign_country=CONCAT_WS('_', case when cm.cost_type='cpa' 
	then cast(ml.unhidden_date as date) end, 
ml.dialer_id,ml.campaign_id,ml.country)
left join public_brm.campaign_expenses_transformed_dbt cet on cet.campaign_country_date_dialer=CONCAT_WS('_',ml.campaign_id,ml.country, 
case when cm.cost_type ='cpl' then cast(ml.created_date as date)
when cm.cost_type ='cpa' and un.date_campaign_country is not null then cast(ml.unhidden_date as date)
when cm.cost_type ='cpa' and cast(ml.unhidden_date as date)>cast(ml.created_date as date) and cast(ml.ftd_date as date) is null 
 	then cast(ml.unhidden_date as date)
when cm.cost_type ='cpa' and cast(ml.ftd_date as date) is null then cast(ml.created_date as date)
when cm.cost_type ='cpa' and cast(ml.ftd_date as date)>cast(ml.created_date as date) then cast(ml.ftd_date as date) 
else cast(ml.created_date as date)  end, ml.dialer_id)
left join ftd_cte ft ON ft.date_campaign_country=CONCAT_WS('_', case when cm.cost_type ='cpl' then cast(ml.created_date as date)
when cm.cost_type ='cpa' and un.date_campaign_country is not null then cast(ml.unhidden_date as date)
when cm.cost_type ='cpa' and cast(ml.unhidden_date as date)>cast(ml.created_date as date) and cast(ml.ftd_date as date) is null 
then cast(ml.unhidden_date as date)
when cm.cost_type ='cpa' and cast(ml.ftd_date as date) is null and cast(ml.unhidden_date as date) is null then cast(ml.created_date as date)
when cm.cost_type ='cpa' and cast(ml.ftd_date as date)>cast(ml.created_date as date) then cast(ml.ftd_date as date)
else cast(ml.created_date as date) end, 
ml.dialer_id,ml.campaign_id,ml.country)
group by ml.dialer_id, ml.dialer_campaign_id, ml.country, ml.campaign_id, cm.affiliate_id, cm.cost_type, ml.cost, cet.expense, 
ml.cost_at_create, cet.expense, ft.ftd_count,
case when cm.cost_type ='cpl' then cast(ml.created_date as date)
when cm.cost_type ='cpa' and un.date_campaign_country is not null then cast(ml.unhidden_date as date)
when cm.cost_type ='cpa' and cast(ml.unhidden_date as date)>cast(ml.created_date as date) and cast(ml.ftd_date as date) is null 
	then cast(ml.unhidden_date as date)
when cm.cost_type ='cpa' and cast(ml.ftd_date as date) is null then cast(ml.created_date as date)
when cm.cost_type ='cpa' and cast(ml.ftd_date as date)>cast(ml.created_date as date) then cast(ml.ftd_date as date) 
else cast(ml.created_date as date) end),

total_cte_cost AS (select date, dialer_id, dialer_campaign_id, country, campaign_id, affiliate_id, campaign_country_date_dialer, sum(individual_cost) as total_cost from total_cte group by date, dialer_id, dialer_campaign_id, country, campaign_id, affiliate_id, campaign_country_date_dialer)

select distinct
tc.date,
tc.dialer_id,
tc.dialer_campaign_id,
tc.country,
tc.affiliate_id ,
tc.campaign_id,
tc.expense,
tc.individual_cost,
tc.actual_cost,
tcc.total_cost,
tc.campaign_country_date_dialer_cost,
(tc.individual_cost / NULLIF(tcc.total_cost,0)) * tc.expense as weighted_expense
from total_cte tc
left join total_cte_cost tcc ON tcc.campaign_country_date_dialer=CONCAT_WS('_',tc.campaign_id, tc.country, tc.date , tc.dialer_id)
GROUP BY tc.dialer_id, tc.dialer_campaign_id,
tc.country,tc.affiliate_id, 
tc.expense,
tc.campaign_id,  tcc.total_cost, tc.individual_cost, tc.date, tc.campaign_country_date_dialer_cost, tc.actual_cost

UNION ALL
SELECT
cast(ie.expense_date as date) as date, 
ie.dialer as dialer_id, 
ie.dialer_campaign_id,
ie.country,
ie.affiliate_id,
ie.campaign_id,
ie.expense,
0 AS individual_cost,
0 AS actual_cost,
0 AS total_cost,
CONCAT_WS('_',ie.campaign_id,ie.country,cast(ie.expense_date as date),ie.dialer,0),
ie.expense AS weighted_expense
FROM public_brm.independent_expenses_dbt ie
