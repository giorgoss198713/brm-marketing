select 
ml.id, 
sales_lead_id, 
dialer_lead_id,
created_date, 
cast(created_date as date) as created_day,
case when hidden is false and is_fake is false and unhidden_date is not null and ftd_date>unhidden_date then unhidden_date
else ftd_date end as ftd_date, 
unhidden_date,
campaign_id, 
country, 
concat_ws('_',dialer_name,country) as dialer_country,
dialer_agent,
dialer_error, 
dialer_calls_count, 
utm_source, 
utm_medium, 
source_id,
ftd, 
ftd_deposit_amount, 
redeposit, 
redeposits_amount, 
last_redeposit_date, 
cost, 
hidden, 
selling_cost, 
cost_at_create, 
dialer_id,
dialer_status,
CASE WHEN dialer_name='C17' THEN 'EN'
    WHEN dialer_name='C2' AND ml.dialer_campaign_id=539 THEN 'TR/AZ'
    WHEN dialer_name='C2' AND ml.dialer_campaign_id!=539 THEN 'RU'
    WHEN dialer_name='C4' THEN 'FR'
    WHEN dialer_name='C6' THEN 'TH'
    WHEN dialer_name='CB10' THEN 'BR1'
    WHEN dialer_name='CB9' AND ml.dialer_campaign_id IN (169,170) THEN 'ITL'
    WHEN dialer_name='CB9' AND ml.dialer_campaign_id NOT IN (169,170) THEN 'BR2'
    ELSE 'Unknown' END AS dialer_language,
CASE WHEN dialer_name='C17' THEN 'C17 - EN'
    WHEN dialer_name='C2' AND ml.dialer_campaign_id=539 THEN 'C2 - TR/AZ'
    WHEN dialer_name='C2' AND ml.dialer_campaign_id!=539 THEN 'C2 - RU'
    WHEN dialer_name='C4' THEN 'C4 - FR'
    WHEN dialer_name='C6' THEN 'C6 - TH'
    WHEN dialer_name='CB10' THEN 'CB10 - BR1'
    WHEN dialer_name='CB9' AND ml.dialer_campaign_id IN (169,170) THEN 'CB9 - ITL'
    WHEN dialer_name='CB9' AND ml.dialer_campaign_id NOT IN (169,170) THEN 'CB9 - BR2'
    ELSE 'Unknown' END AS dialer_name_language,
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
CASE WHEN (dialer_status iLIKE '%Call Again%'
or dialer_status iLIKE '%HUCC%')
THEN 'Valid Engage'
ELSE 'Not Valid Engage' END as valid_engage,
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
cm.inhouse_data_live,
(CASE 
WHEN (to_char(created_date, 'HH24'))::numeric>=0 AND (to_char(created_date, 'HH24'))::numeric<1 
THEN '00:00-00:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=1 AND (to_char(created_date, 'HH24'))::numeric<2
THEN '01:00-01:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=2 AND (to_char(created_date, 'HH24'))::numeric<3
THEN '02:00-02:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=3 AND (to_char(created_date, 'HH24'))::numeric<4
THEN '03:00-03:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=4 AND (to_char(created_date, 'HH24'))::numeric<5
THEN '04:00-04:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=5 AND (to_char(created_date, 'HH24'))::numeric<6
THEN '05:00-05:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=6 AND (to_char(created_date, 'HH24'))::numeric<7
THEN '06:00-06:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=7 AND (to_char(created_date, 'HH24'))::numeric<8
THEN '07:00-07:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=8 AND (to_char(created_date, 'HH24'))::numeric<9
THEN '08:00-08:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=9 AND (to_char(created_date, 'HH24'))::numeric<10
THEN '09:00-09:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=10 AND (to_char(created_date, 'HH24'))::numeric<11
THEN '10:00-10:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=11 AND (to_char(created_date, 'HH24'))::numeric<12
THEN '11:00-11:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=12 AND (to_char(created_date, 'HH24'))::numeric<13
THEN '12:00-12:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=13 AND (to_char(created_date, 'HH24'))::numeric<14
THEN '13:00-13:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=14 AND (to_char(created_date, 'HH24'))::numeric<15
THEN '14:00-14:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=15 AND (to_char(created_date, 'HH24'))::numeric<16
THEN '15:00-15:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=16 AND (to_char(created_date, 'HH24'))::numeric<17
THEN '16:00-16:59'
WHEN (to_char(created_date, 'HH24'))::numeric>=17 AND (to_char(created_date, 'HH24'))::numeric<18
THEN '17:00-17:59'
WHEN (to_char(created_date, 'HH24'))::numeric >= 18 AND (to_char(created_date, 'HH24'))::numeric < 19
THEN '18:00-18:59'
WHEN (to_char(created_date, 'HH24'))::numeric >= 19 AND (to_char(created_date, 'HH24'))::numeric < 20
THEN '19:00-19:59'
WHEN (to_char(created_date, 'HH24'))::numeric >= 20 AND (to_char(created_date, 'HH24'))::numeric < 21
THEN '20:00-20:59'
WHEN (to_char(created_date, 'HH24'))::numeric >= 21 AND (to_char(created_date, 'HH24'))::numeric < 22
THEN '21:00-21:59'
WHEN (to_char(created_date, 'HH24'))::numeric >= 22 AND (to_char(created_date, 'HH24'))::numeric < 23
THEN '22:00-22:59'
WHEN (to_char(created_date, 'HH24'))::numeric >= 23 AND (to_char(created_date, 'HH24'))::numeric < 24
THEN '23:00-23:59'
ELSE 'Other' END) AS created_time_bucket,
(CASE 
WHEN (to_char(ftd_date, 'HH24'))::numeric>=0 AND (to_char(ftd_date, 'HH24'))::numeric<1 
THEN '00:00-00:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=1 AND (to_char(ftd_date, 'HH24'))::numeric<2
THEN '01:00-01:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=2 AND (to_char(ftd_date, 'HH24'))::numeric<3
THEN '02:00-02:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=3 AND (to_char(ftd_date, 'HH24'))::numeric<4
THEN '03:00-03:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=4 AND (to_char(ftd_date, 'HH24'))::numeric<5
THEN '04:00-04:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=5 AND (to_char(ftd_date, 'HH24'))::numeric<6
THEN '05:00-05:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=6 AND (to_char(ftd_date, 'HH24'))::numeric<7
THEN '06:00-06:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=7 AND (to_char(ftd_date, 'HH24'))::numeric<8
THEN '07:00-07:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=8 AND (to_char(ftd_date, 'HH24'))::numeric<9
THEN '08:00-08:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=9 AND (to_char(ftd_date, 'HH24'))::numeric<10
THEN '09:00-09:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=10 AND (to_char(ftd_date, 'HH24'))::numeric<11
THEN '10:00-10:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=11 AND (to_char(ftd_date, 'HH24'))::numeric<12
THEN '11:00-11:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=12 AND (to_char(ftd_date, 'HH24'))::numeric<13
THEN '12:00-12:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=13 AND (to_char(ftd_date, 'HH24'))::numeric<14
THEN '13:00-13:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=14 AND (to_char(ftd_date, 'HH24'))::numeric<15
THEN '14:00-14:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=15 AND (to_char(ftd_date, 'HH24'))::numeric<16
THEN '15:00-15:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=16 AND (to_char(ftd_date, 'HH24'))::numeric<17
THEN '16:00-16:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric>=17 AND (to_char(ftd_date, 'HH24'))::numeric<18
THEN '17:00-17:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric >= 18 AND (to_char(ftd_date, 'HH24'))::numeric < 19
THEN '18:00-18:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric >= 19 AND (to_char(ftd_date, 'HH24'))::numeric < 20
THEN '19:00-19:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric >= 20 AND (to_char(ftd_date, 'HH24'))::numeric < 21
THEN '20:00-20:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric >= 21 AND (to_char(ftd_date, 'HH24'))::numeric < 22
THEN '21:00-21:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric >= 22 AND (to_char(ftd_date, 'HH24'))::numeric < 23
THEN '22:00-22:59'
WHEN (to_char(ftd_date, 'HH24'))::numeric >= 23 AND (to_char(ftd_date, 'HH24'))::numeric < 24
THEN '23:00-23:59'
ELSE NULL END) as ftd_time_bucket,
(CASE 
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=0 AND (to_char(unhidden_date, 'HH24'))::numeric<1 
THEN '00:00-00:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=1 AND (to_char(unhidden_date, 'HH24'))::numeric<2
THEN '01:00-01:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=2 AND (to_char(unhidden_date, 'HH24'))::numeric<3
THEN '02:00-02:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=3 AND (to_char(unhidden_date, 'HH24'))::numeric<4
THEN '03:00-03:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=4 AND (to_char(unhidden_date, 'HH24'))::numeric<5
THEN '04:00-04:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=5 AND (to_char(unhidden_date, 'HH24'))::numeric<6
THEN '05:00-05:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=6 AND (to_char(unhidden_date, 'HH24'))::numeric<7
THEN '06:00-06:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=7 AND (to_char(unhidden_date, 'HH24'))::numeric<8
THEN '07:00-07:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=8 AND (to_char(unhidden_date, 'HH24'))::numeric<9
THEN '08:00-08:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=9 AND (to_char(unhidden_date, 'HH24'))::numeric<10
THEN '09:00-09:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=10 AND (to_char(unhidden_date, 'HH24'))::numeric<11
THEN '10:00-10:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=11 AND (to_char(unhidden_date, 'HH24'))::numeric<12
THEN '11:00-11:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=12 AND (to_char(unhidden_date, 'HH24'))::numeric<13
THEN '12:00-12:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=13 AND (to_char(unhidden_date, 'HH24'))::numeric<14
THEN '13:00-13:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=14 AND (to_char(unhidden_date, 'HH24'))::numeric<15
THEN '14:00-14:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=15 AND (to_char(unhidden_date, 'HH24'))::numeric<16
THEN '15:00-15:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=16 AND (to_char(unhidden_date, 'HH24'))::numeric<17
THEN '16:00-16:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric>=17 AND (to_char(unhidden_date, 'HH24'))::numeric<18
THEN '17:00-17:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric >= 18 AND (to_char(unhidden_date, 'HH24'))::numeric < 19
THEN '18:00-18:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric >= 19 AND (to_char(unhidden_date, 'HH24'))::numeric < 20
THEN '19:00-19:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric >= 20 AND (to_char(unhidden_date, 'HH24'))::numeric < 21
THEN '20:00-20:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric >= 21 AND (to_char(unhidden_date, 'HH24'))::numeric < 22
THEN '21:00-21:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric >= 22 AND (to_char(unhidden_date, 'HH24'))::numeric < 23
THEN '22:00-22:59'
WHEN (to_char(unhidden_date, 'HH24'))::numeric >= 23 AND (to_char(unhidden_date, 'HH24'))::numeric < 24
THEN '23:00-23:59'
ELSE NULL END) as unhidden_time_bucket
from public_brm.marketing_leads ml
left join public_brm.campaigns_v2_dbt cm on ml.campaign_id=cm.id
left join public_brm.affiliates aff on cm.affiliate_id=aff.id
WHERE
is_test is false