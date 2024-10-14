select id, name, description,
affiliate_id, cost_type, dialer, dialer_campaign_id, campaign_budget, 
(CASE WHEN description iLIKE '%DATA%' THEN 'DATA'
WHEN description iLIKE '%INHOUSE%' THEN 'INHOUSE'
ELSE 'LIVE' END) AS inhouse_data_live,
CASE WHEN dialer=30 THEN 'EN'
    WHEN dialer=37 AND dialer_campaign_id=539 THEN 'TR/AZ'
    WHEN dialer=37 AND dialer_campaign_id!=539 THEN 'RU'
    WHEN dialer=7 THEN 'FR'
    WHEN dialer=47 THEN 'FR'
    WHEN dialer=17 THEN 'TH'
    WHEN dialer=3 THEN 'BR1'
    WHEN dialer=5 AND dialer_campaign_id IN (169,170) THEN 'ITL'
    WHEN dialer=5 AND dialer_campaign_id NOT IN (169,170) THEN 'BR2'
    WHEN dialer=22 THEN 'C15'
    WHEN dialer=24 THEN 'C16'
    WHEN dialer=6 THEN 'C3'
    ELSE 'Unknown' END AS dialer_language,
CASE WHEN dialer=30 THEN 'C17 - EN'
    WHEN dialer=37 AND dialer_campaign_id=539 THEN 'C2 - TR/AZ'
    WHEN dialer=37 AND dialer_campaign_id!=539 THEN 'C2 - RU'
    WHEN dialer=7 THEN 'C4 - FR'
    WHEN dialer=47 THEN 'C7 - FR'
    WHEN dialer=17 THEN 'C6 - TH'
    WHEN dialer=3 THEN 'CB10 - BR1'
    WHEN dialer=5 AND dialer_campaign_id IN (169,170) THEN 'CB9 - ITL'
    WHEN dialer=5 AND dialer_campaign_id NOT IN (169,170) THEN 'CB9 - BR2'
    WHEN dialer=22 THEN 'C15 - SP'
    WHEN dialer=24 THEN 'C16 - ARA'
    WHEN dialer=6 THEN 'C3 - ITL'
    ELSE 'Unknown' END AS dialer_name_language
from public_brm.campaigns