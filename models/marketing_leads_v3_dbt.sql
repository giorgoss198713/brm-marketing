select ml.id, sales_lead_id, created_date, ftd_date, unhidden_date,
campaign_id, country, dialer_lead_id, dialer_agent,
dialer_error, dialer_calls_count, utm_source, utm_medium, source_id,ftd, ftd_deposit_amount, redeposit, 
redeposits_amount, last_redeposit_date, cost, hidden, selling_cost, cost_at_create, dialer_id,
dialer_status,
CASE WHEN dialer_name='C17' THEN 'EN'
    WHEN dialer_name='C2' AND ml.dialer_campaign_id=539 THEN 'TR/AZ'
    WHEN dialer_name='C2' AND ml.dialer_campaign_id!=539 THEN 'RU'
    WHEN dialer_name='C4' THEN 'FR'
    WHEN dialer_name='C6' THEN 'TH'
    WHEN dialer_name='CB10' THEN 'BR1'
    WHEN dialer_name='CB9' THEN 'BR2'
    ELSE 'Unknown' END AS dialer_language,
CASE 
WHEN dialer_status iLIKE '%Ghost%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%hang up%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%bad line%' then 'ENGAGE'
WHEN dialer_status iLIKE '%blacklisted%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%BL MANUAL%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%BLDNC%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%block countries%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%busy%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%call again%' then 'ENGAGE'
WHEN dialer_status iLIKE '%cbp%' then 'ENGAGE'
WHEN dialer_status iLIKE '%check number%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%choose status%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%default status%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%do not call%' then 'ENGAGE'
WHEN dialer_status iLIKE '%duplicates%' then 'NOT ENGAGE'
WHEN dialer_status='EPA' then 'ENGAGE'
WHEN dialer_status='EPA 1' then 'ENGAGE'
WHEN dialer_status='EPA_S' then 'ENGAGE'
WHEN dialer_status='EPAT' then 'ENGAGE'
WHEN dialer_status iLIKE '%Failed EPA%' then 'ENGAGE'
WHEN dialer_status iLIKE '%failed to connect%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%foreign%' then 'ENGAGE'
WHEN dialer_status iLIKE '%general call back%' then 'ENGAGE'
WHEN dialer_status iLIKE '%hucc%' then 'ENGAGE'
WHEN dialer_status='Incoming - Reset' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%institutional%' then 'ENGAGE'
WHEN dialer_status iLIKE '%invalid number%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%barrier%' then 'ENGAGE'
WHEN dialer_status iLIKE '%low quality%' then 'ENGAGE'
WHEN dialer_status iLIKE '%new lead%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%no answer%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%not interested%' then 'ENGAGE'
WHEN dialer_status iLIKE '%old do not call%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%old do no call%' then 'NOT ENGAGE'
WHEN dialer_status='Old EPA' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%Pending EPA%' then 'ENGAGE'
WHEN dialer_status iLIKE '%system - answer%' then 'NOT ENGAGE'
WHEN dialer_status='Transfer Dialer' then 'NULL'
WHEN dialer_status iLIKE '%underage%' then 'ENGAGE'
WHEN dialer_status iLIKE '%voicemail%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%voice mail%' then 'NOT ENGAGE'
WHEN dialer_status iLIKE '%wrong person%' then 'ENGAGE'
WHEN dialer_status='Z EPA' then 'ENGAGE'
WHEN dialer_status='Z_EPA 2' then 'ENGAGE'
WHEN dialer_status='Z EPA(Disregard)' then 'ENGAGE'
WHEN dialer_status IS NULL then 'NULL'
ELSE 'Unknown'
END AS engagement_status,
CASE 
WHEN dialer_status iLIKE '%Ghost%' then 'Ghost Call'
WHEN dialer_status iLIKE '%hang up%' then 'Auto Hang Up'
WHEN dialer_status iLIKE '%bad line%' then 'Bad Line'
WHEN dialer_status iLIKE '%blacklisted%' then 'Blacklisted Prefix'
WHEN dialer_status iLIKE '%BL MANUAL%' then 'BL MANUAL -  DNC LIST'
WHEN dialer_status iLIKE '%BLDNC%' then 'BL MANUAL -  DNC LIST'
WHEN dialer_status iLIKE '%block countries%' then 'BL MANUAL -  DNC LIST'
WHEN dialer_status iLIKE '%busy%' then 'Busy'
WHEN dialer_status iLIKE '%call again - general%' then 'Call Again - General'
WHEN dialer_status iLIKE '%call again general%' then 'Call Again - General'
WHEN dialer_status iLIKE '%call again - personal%' then 'Call Again - Personal'
WHEN dialer_status iLIKE '%call again personal%' then 'Call Again - Personal'
WHEN dialer_status iLIKE '%cbp%' then 'Call Again - Personal'
WHEN dialer_status iLIKE '%check number%' then 'Check Number'
WHEN dialer_status iLIKE '%choose status%' then 'Choose Status'
WHEN dialer_status iLIKE '%default status%' then 'Choose Status'
WHEN dialer_status iLIKE '%do not call%' then 'Do Not Call'
WHEN dialer_status iLIKE '%duplicates%' then 'Duplicates'
WHEN dialer_status='EPA' then 'EPA'
WHEN dialer_status='EPA 1' then 'EPA'
WHEN dialer_status='EPA_S' then 'EPA'
WHEN dialer_status='EPAT' then 'EPA'
WHEN dialer_status iLIKE '%Failed EPA%' then 'Failed EPA'
WHEN dialer_status iLIKE '%failed to connect%' then 'Failed To Connect - System'
WHEN dialer_status iLIKE '%foreign%' then 'Foreign'
WHEN dialer_status iLIKE '%general call back%' then 'Call Again - General'
WHEN dialer_status iLIKE '%hucc%' then 'HUCC'
WHEN dialer_status='Incoming - Reset' then 'Incoming - Reset'
WHEN dialer_status iLIKE '%institutional%' then 'Institutional'
WHEN dialer_status iLIKE '%invalid number%' then 'Invalid Number'
WHEN dialer_status iLIKE '%barrier%' then 'Language Barrier'
WHEN dialer_status iLIKE '%low quality%' then 'Low Quality Client'
WHEN dialer_status iLIKE '%new lead%' then 'New Lead'
WHEN dialer_status iLIKE '%no answer%' then 'No Answer'
WHEN dialer_status iLIKE '%not interested%' then 'Not Interested'
WHEN dialer_status iLIKE '%old do not call%' then 'Do Not Call'
WHEN dialer_status iLIKE '%old do no call%' then 'Do Not Call'
WHEN dialer_status='Old EPA' then 'Old EPA'
WHEN dialer_status iLIKE '%Pending EPA%' then 'Pending EPA'
WHEN dialer_status iLIKE '%system - answer%' then 'System - Answer (Dropped)'
WHEN dialer_status='Transfer Dialer' then 'Transfer Dialer'
WHEN dialer_status iLIKE '%underage%' then 'Underage'
WHEN dialer_status iLIKE '%voicemail%' then 'VoiceMail'
WHEN dialer_status iLIKE '%voice mail%' then 'VoiceMail'
WHEN dialer_status iLIKE '%wrong person%' then 'Wrong Person'
WHEN dialer_status='Z EPA' then 'EPA'
WHEN dialer_status='Z_EPA 2' then 'EPA'
WHEN dialer_status='Z EPA(Disregard)' then 'Failed EPA'
WHEN dialer_status IS NULL then NULL
ELSE 'Unknown'
END AS dialer_type,
dialer_name,
ml.dialer_campaign_id, is_fake,
dialer_comment,
(CASE WHEN (dialer_status iLIKE '%BL MANUAL%'
or dialer_status iLIKE '%Blacklisted Prefix%'
or dialer_status iLIKE '%Institutional%') THEN 'Invalid'
WHEN (dialer_status iLIKE '%New Lead%'
or dialer_status IS NULL) THEN 'Neutral'
WHEN ( dialer_status iLIKE '%Foreign%'
or dialer_status iLIKE '%Invalid Number%'
or dialer_status iLIKE '%Language Barrier%'
or dialer_status iLIKE '%Underage%'
or dialer_status iLIKE '%Wrong Person%') THEN 'Invalid Deal'
ELSE 'Valid' END) as invalid_status,
ROUND(ftd_deposit_amount / 50) * 50 AS rounded_ftd_deposit_amount,
(CASE WHEN ftd_deposit_amount>0 
AND ftd_deposit_amount<100 THEN '01. $1-99'
WHEN ftd_deposit_amount>=100
AND ftd_deposit_amount<150 THEN '02. $100-149'
WHEN ftd_deposit_amount>=150
AND ftd_deposit_amount<200 THEN '03. $150-199'
WHEN ftd_deposit_amount>=200
AND ftd_deposit_amount<300 THEN '04. $200-299'
WHEN ftd_deposit_amount>=300
AND ftd_deposit_amount<400 THEN '05. $300-399'
WHEN ftd_deposit_amount>=400
AND ftd_deposit_amount<500 THEN '06. $400-499'
WHEN ftd_deposit_amount>=500 THEN '07. $500+'
ELSE 'Not an FTD'
END) AS ftd_bucket,
(CASE WHEN  ftd_deposit_amount>0
AND ftd_deposit_amount<200 THEN 100
WHEN ftd_deposit_amount>=200
AND ftd_deposit_amount<350 THEN 250
WHEN ftd_deposit_amount>=350
AND ftd_deposit_amount<700 THEN 400
WHEN ftd_deposit_amount>=700
AND ftd_deposit_amount<900 THEN 800
WHEN ftd_deposit_amount>=900 THEN 900
ELSE NULL
END) AS ftd_approx,
cm.cost_type,
cm.name as campaign_name,
cm.affiliate_id,
aff.name as affiliate_name,
cm.inhouse_data_live
from public_brm.marketing_leads ml
left join public_brm.campaigns_v2_dbt cm on ml.campaign_id=cm.id
left join public_brm.affiliates aff on cm.affiliate_id=aff.id
WHERE
is_test is false
AND CAST(created_date AS Date)<= CURRENT_DATE - INTERVAL '1 day'