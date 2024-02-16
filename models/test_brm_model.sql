select id, created_date, dialer_id, (case when dialer_id=3 then 'CB10' end) as dialer_name 
from public_brm.marketing_leads
where
created_date>'2024-02-01'
order by created_date desc