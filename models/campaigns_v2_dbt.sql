select id, name, description,
affiliate_id, cost_type, dialer, dialer_campaign_id, campaign_budget, 
(CASE WHEN description iLIKE '%DATA%' THEN 'DATA'
WHEN description iLIKE '%INHOUSE%' THEN 'INHOUSE'
ELSE 'LIVE' END) AS inhouse_data_live
from public_brm.campaigns