    SELECT 
        st.id,
        lead_id,
        st.created_date,
        ROW_NUMBER() OVER (PARTITION BY lead_id ORDER BY st.created_date) AS rn,
         updated_date, amount, 
amount_in_usd,
CASE WHEN round(cast(amount_in_usd as numeric),0)>0 AND round(cast(amount_in_usd as numeric),0)<=175
THEN '$100'
WHEN round(cast(amount_in_usd as numeric),0)>175 AND round(cast(amount_in_usd as numeric),0)<=275
THEN '$250'
WHEN round(cast(amount_in_usd as numeric),0)>275 AND round(cast(amount_in_usd as numeric),0)<=350
THEN '$300'
WHEN round(cast(amount_in_usd as numeric),0)>350 AND round(cast(amount_in_usd as numeric),0)<=450
THEN '$400'
WHEN round(cast(amount_in_usd as numeric),0)>450 AND round(cast(amount_in_usd as numeric),0)<=550
THEN '$500'
WHEN round(cast(amount_in_usd as numeric),0)>550 
THEN '$550+'
END AS usd_bucket,
product_id, product_name, payment_profile, status, currency,
payment_method, psp_transaction_id, st.is_fake, confirmed, type, checked, approved_date, 
psp, payments_pro_transaction_id, rejected_Date, crypto_currency, crypto_amount, wire_transfer_confirmation, 
add_to_balance, sync_error,
notes, 
CASE 
WHEN (notes iLIKE '%3DS%' OR notes iLIKE '%Authentication%') THEN 'Authentication Failed'
WHEN (notes iLIKE '%wrong card%' or notes ilike '%Invalid card number%' OR notes ilike '%+Declined-+Invalid+Card%' OR notes ilike '%800.100.151%') THEN 'Wrong Card Number'
WHEN (notes iLike '%Honour%' OR  notes iLike '%45005%' OR notes iLike '%Honor%') THEN 'Do Not Honour'
WHEN notes iLike '%Restricted%' THEN 'Restricted Card'
WHEN notes iLike '%Expired%' THEN 'Expired Payment'
WHEN (notes iLike '%time-out%' OR notes iLike '%timeout%' OR notes iLike '%timed out%' OR notes iLike '%exceeds defined%' OR notes iLike '%46020%' OR notes ilike '%Request+Timed+Out%' OR notes ilike '%timedout%') THEN 'Request Time-Out'
WHEN (notes iLike '%not permitted%' OR notes ilike '%not+permitted+to+cardholder%') THEN 'Not Permitted'
WHEN (notes iLike '%Blacklisted%' OR notes iLike '%42008%' OR notes ilike '%Transaction country is not allowed%' OR notes ilike '%Country+not+allowed%') THEN 'Country Blacklisted'
WHEN (notes iLike '%insufficient%' or notes ilike '%45051%' OR notes ilike '%not sufficient%' OR notes ilike '%Not+sufficient+funds%' OR notes ilike '%No sufficient funds%') THEN 'Insufficient Funds'
WHEN notes iLike '%too high%' THEN 'Too High Amount'
WHEN notes iLike '%malfunction%' THEN 'System Malfunction'
WHEN (notes iLike '%cancelled%' OR notes iLike '%canceled%') THEN 'Cancelled'
WHEN (notes iLike '%enrolled%' OR notes iLike '%43004%') THEN 'Card Not Enrolled'
WHEN (notes iLike '%not permitted%' OR notes iLike '%45057%') THEN 'Transaction Not Permitted'
WHEN (notes iLike '%scheme rule%' OR notes iLike '%42401%') THEN 'Rejected by Scheme Rule'
WHEN (notes iLike '%issuer system%' OR notes iLike '%45096%' OR notes ilike '%Issuing bank error%') THEN 'Issuer System Error'
WHEN (notes iLike '%cvv%' OR notes iLike '%45055%') THEN 'Wrong CVV'
WHEN (notes iLike '%invalid transaction%' OR notes iLike '%45012%') THEN 'Invalid Transactions'
WHEN notes iLike '%manipulation%' THEN 'Suspected Manipulation'
WHEN notes iLike '%fraud%' THEN 'Suspected Fraud'
WHEN notes iLike '%Wrong Expiry%' THEN 'Wrong Expiry'
WHEN (notes iLike '%Card is Blocked%' OR notes iLike '%Card Blocked%') THEN 'Card Blocked'
WHEN (notes iLike '%exceeded%' OR notes iLike '%42121%' OR notes iLike '%800.100.162%' OR notes iLike '%exceeds%') THEN 'Limit Exceeded'
WHEN (notes iLike '%PSP Team%' OR notes iLIKE '%PSPTeam%') THEN 'PSPTeam Account'
WHEN notes iLike '%Unsupported%' THEN 'Unsupported Payment Type'
WHEN (notes iLike '%technical error%' OR notes iLike '%46001%' OR notes ilike '%+Internal+Processing+Error%') THEN 'System or Technical Error'
WHEN (notes iLike '%registration%' OR notes iLike '%100.250.203%') THEN 'Registration Not Valid'
WHEN (notes iLike '%account blocked%' OR notes iLike '%800.100.172%') THEN 'Account Blocked'
WHEN notes iLike '%800.100.152%' THEN 'Declined by Authorization System'
WHEN (notes iLike '%invalid bank account number%' OR notes iLike '%100.100.101%' OR notes ilike '%+Invalid+account+number%') THEN 'Invalid Bank Account Number'
WHEN (notes ilike '%Invalid cardholder name%' OR notes ilike '%cardholder_name%') THEN 'Invalid Cardholder Name'
WHEN notes iLike '%Duplicate%' THEN 'Duplicate Transactions'
WHEN (notes iLike '%maximum number%' OR notes ilike '%800.120.101%') THEN 'Max Number of Transactions reached'
WHEN notes iLike '%Security Code%' THEN 'Security Code Mismatch'
WHEN (notes iLike '%Pick Up%' OR  notes iLike '%Pick-Up%')  THEN 'Pick Up Card'
WHEN (notes iLike '%Violation of law%' OR  notes iLike '%45093%')  THEN 'Violation of Law'
WHEN notes iLike '%44053%' THEN 'Invalid Request Parameter'
WHEN notes iLike '%account closed%' THEN 'Account Closed'
WHEN notes iLike '%auto decline%' THEN 'Auto Decline'
WHEN notes iLike '% Declined Merchant%' THEN 'Declined Merchant'
WHEN notes iLike '%45046%'  THEN 'Card Account is Closed'
WHEN (notes iLike '%45060%' OR notes iLike '%45160%') THEN 'Cancel Recurring Contract'
WHEN notes iLike '%45063%'  THEN 'Security Violation'
WHEN (notes iLike '%45082%' OR notes ilike '%rejected by issuer%' OR notes ilike '%Bank decline%' OR notes ilike '%Issuer declined the transaction%%')  THEN 'Issuer Decline'
WHEN notes iLike '%45099%'  THEN 'Transaction Requires SCA'
WHEN notes iLike '%45282%'  THEN 'Issuer Policy'
WHEN notes iLike '%46014%'  THEN ' No Routing Options Available'
WHEN notes iLike '%compliance reasons%'  THEN 'Compliance Reasons'
WHEN notes iLike '%Risk check decline%'  THEN 'Risk Check Deadline'
WHEN notes iLIKE '%Method ''Checkout''%' THEN 'Method Checkout Unsupported'
WHEN notes iLIKE '%Suspected deception%' THEN 'Suspected Deception'
WHEN notes iLIKE '%host connection%' THEN 'Host Connection Issue'
WHEN notes iLIKE '%incorrect data entered%' THEN 'Incorrect Data Entered'
WHEN notes iLIKE '%Declined by Processor%' THEN 'Declined by Processor'
WHEN notes iLIKE '%Declined Merchant%' THEN 'Declined Merchant'
WHEN notes iLIKE '%Declined by card issuer%' THEN 'Declined by Card Issuer'
WHEN notes iLIKE '%600.200.500%' THEN 'Not Configured for this Ccy'
WHEN notes iLIKE '%Provider account is not available%' THEN 'Provider Account Not Available'
WHEN notes iLIKE '%100.100.400%' THEN 'No CC/Bank Account Holder'
WHEN notes ilike '%Invalid Request Parameter%' THEN 'Invalid Request Parameter'
WHEN notes ilike '%44058%' THEN 'Invalid Amount'
WHEN notes ilike '%44030%' THEN 'Issuer Format Error'
WHEN notes ilike '%buyer falls outside%' THEN 'Buyer not in Risk Guidelines'
WHEN (notes ilike '%card data security%' OR notes ilike '%security breach%' OR notes ilike '%+Security+violation%') THEN 'Security Breach'
WHEN notes ilike '%Restrictions for the customer card%' THEN 'Card Restrictions'
WHEN notes ilike '%General+decline+of+the+card%' THEN 'General Card Decline'
WHEN notes ilike '%+Inactive+card+or+card%' THEN 'Inactive Card'
WHEN notes ilike '%rejected+by+Decision+Manager%' THEN 'Rejected by Decision Manager'
WHEN notes ilike '%deserted%' THEN 'Deserted'
WHEN notes ilike '%45030%' THEN 'Issuer Format Error'
WHEN notes ilike '%FIN012%' THEN 'General Payment Error'
WHEN notes ilike '%REJECTED_BY_THIRD%' THEN 'Rejected by Third Party'
WHEN notes ilike '%42102%' THEN 'Too Low Amount'
WHEN notes ilike '%lost_card%' THEN 'Lost Card'
WHEN notes ilike '%800.100.161%' THEN 'Too many invalid tries'
WHEN notes ilike '%800.100.166%' THEN 'Incorrect PIN'
WHEN notes ilike '%invalid_pin%' THEN 'Incorrect PIN'
WHEN notes ilike '%800.100.190%' THEN 'Invalid Configuration Data'
WHEN notes ilike '%100.100.401%' THEN 'Invalid Cardholder Name'
WHEN notes ilike '%new_card_not_unblocked%' THEN 'New Card not Unblocked'
ELSE 'Unspecified Reason'
END AS decline_reason,
CASE 
WHEN (notes iLIKE '%3DS%' OR notes iLIKE '%Authentication%') THEN concat_ws('_',lead_id,1)
WHEN (notes iLIKE '%wrong card%' or notes ilike '%Invalid card number%' OR notes ilike '%+Declined-+Invalid+Card%' OR notes ilike '%800.100.151%') THEN concat_ws('_',lead_id,2)
WHEN (notes iLike '%Honour%' OR  notes iLike '%45005%' OR notes iLike '%Honor%') THEN concat_ws('_',lead_id,3)
WHEN notes iLike '%Restricted%' THEN concat_ws('_',lead_id,4)
WHEN notes iLike '%Expired%' THEN concat_ws('_',lead_id,5)
WHEN (notes iLike '%time-out%' OR notes iLike '%timeout%' OR notes iLike '%timed out%' OR notes iLike '%exceeds defined%' OR notes iLike '%46020%' OR notes ilike '%Request+Timed+Out%' OR notes ilike '%timedout%') THEN concat_ws('_',lead_id,5)
WHEN (notes iLike '%not permitted%' OR notes ilike '%not+permitted+to+cardholder%') THEN concat_ws('_',lead_id,6)
WHEN (notes iLike '%Blacklisted%' OR notes iLike '%42008%' OR notes ilike '%Transaction country is not allowed%' OR notes ilike '%Country+not+allowed%') THEN concat_ws('_',lead_id,7)
WHEN (notes iLike '%insufficient%' or notes ilike '%45051%' OR notes ilike '%not sufficient%' OR notes ilike '%Not+sufficient+funds%' OR notes ilike '%No sufficient funds%') THEN concat_ws('_',lead_id,8)
WHEN notes iLike '%too high%' THEN concat_ws('_',lead_id,9)
WHEN notes iLike '%malfunction%' THEN concat_ws('_',lead_id,10)
WHEN (notes iLike '%cancelled%' OR notes iLike '%canceled%') THEN concat_ws('_',lead_id,11)
WHEN (notes iLike '%enrolled%' OR notes iLike '%43004%') THEN concat_ws('_',lead_id,12)
WHEN (notes iLike '%not permitted%' OR notes iLike '%45057%') THEN concat_ws('_',lead_id,13)
WHEN (notes iLike '%scheme rule%' OR notes iLike '%42401%') THEN concat_ws('_',lead_id,14)
WHEN (notes iLike '%issuer system%' OR notes iLike '%45096%' OR notes ilike '%Issuing bank error%') THEN concat_ws('_',lead_id,15)
WHEN (notes iLike '%cvv%' OR notes iLike '%45055%') THEN concat_ws('_',lead_id,16)
WHEN (notes iLike '%invalid transaction%' OR notes iLike '%45012%') THEN concat_ws('_',lead_id,17)
WHEN notes iLike '%manipulation%' THEN concat_ws('_',lead_id,18)
WHEN notes iLike '%fraud%' THEN concat_ws('_',lead_id,19)
WHEN notes iLike '%Wrong Expiry%' THEN concat_ws('_',lead_id,20)
WHEN (notes iLike '%Card is Blocked%' OR notes iLike '%Card Blocked%') THEN concat_ws('_',lead_id,21)
WHEN (notes iLike '%exceeded%' OR notes iLike '%42121%' OR notes iLike '%800.100.162%' OR notes iLike '%exceeds%') THEN concat_ws('_',lead_id,22)
WHEN (notes iLike '%PSP Team%' OR notes iLIKE '%PSPTeam%') THEN concat_ws('_',lead_id,23)
WHEN notes iLike '%Unsupported%' THEN concat_ws('_',lead_id,24)
WHEN (notes iLike '%technical error%' OR notes iLike '%46001%' OR notes ilike '%+Internal+Processing+Error%') THEN concat_ws('_',lead_id,25)
WHEN (notes iLike '%registration%' OR notes iLike '%100.250.203%') THEN concat_ws('_',lead_id,26)
WHEN (notes iLike '%account blocked%' OR notes iLike '%800.100.172%') THEN concat_ws('_',lead_id,27)
WHEN notes iLike '%800.100.152%' THEN concat_ws('_',lead_id,28)
WHEN (notes iLike '%invalid bank account number%' OR notes iLike '%100.100.101%' OR notes ilike '%+Invalid+account+number%') THEN concat_ws('_',lead_id,29)
WHEN (notes ilike '%Invalid cardholder name%' OR notes ilike '%cardholder_name%') THEN concat_ws('_',lead_id,30)
WHEN notes iLike '%Duplicate%' THEN concat_ws('_',lead_id,31)
WHEN (notes iLike '%maximum number%' OR notes ilike '%800.120.101%') THEN concat_ws('_',lead_id,32)
WHEN notes iLike '%Security Code%' THEN concat_ws('_',lead_id,33)
WHEN (notes iLike '%Pick Up%' OR  notes iLike '%Pick-Up%')  THEN concat_ws('_',lead_id,34)
WHEN (notes iLike '%Violation of law%' OR  notes iLike '%45093%')  THEN concat_ws('_',lead_id,35)
WHEN notes iLike '%44053%' THEN concat_ws('_',lead_id,36)
WHEN notes iLike '%account closed%' THEN concat_ws('_',lead_id,37)
WHEN notes iLike '%auto decline%' THEN concat_ws('_',lead_id,38)
WHEN notes iLike '% Declined Merchant%' THEN concat_ws('_',lead_id,39)
WHEN notes iLike '%45046%'  THEN concat_ws('_',lead_id,40)
WHEN (notes iLike '%45060%' OR notes iLike '%45160%') THEN concat_ws('_',lead_id,41)
WHEN notes iLike '%45063%'  THEN concat_ws('_',lead_id,42)
WHEN (notes iLike '%45082%' OR notes ilike '%rejected by issuer%' OR notes ilike '%Bank decline%' OR notes ilike '%Issuer declined the transaction%%')  THEN concat_ws('_',lead_id,43)
WHEN notes iLike '%45099%'  THEN concat_ws('_',lead_id,44)
WHEN notes iLike '%45282%'  THEN concat_ws('_',lead_id,45)
WHEN notes iLike '%46014%'  THEN concat_ws('_',lead_id,46)
WHEN notes iLike '%compliance reasons%'  THEN concat_ws('_',lead_id,47)
WHEN notes iLike '%Risk check decline%'  THEN concat_ws('_',lead_id,48)
WHEN notes iLIKE '%Method ''Checkout''%' THEN concat_ws('_',lead_id,49)
WHEN notes iLIKE '%Suspected deception%' THEN concat_ws('_',lead_id,50)
WHEN notes iLIKE '%host connection%' THEN concat_ws('_',lead_id,50)
WHEN notes iLIKE '%incorrect data entered%' THEN concat_ws('_',lead_id,51)
WHEN notes iLIKE '%Declined by Processor%' THEN concat_ws('_',lead_id,52)
WHEN notes iLIKE '%Declined Merchant%' THEN concat_ws('_',lead_id,53)
WHEN notes iLIKE '%Declined by card issuer%' THEN concat_ws('_',lead_id,54)
WHEN notes iLIKE '%600.200.500%' THEN concat_ws('_',lead_id,55)
WHEN notes iLIKE '%Provider account is not available%' THEN concat_ws('_',lead_id,56)
WHEN notes iLIKE '%100.100.400%' THEN concat_ws('_',lead_id,57)
WHEN notes ilike '%Invalid Request Parameter%' THEN concat_ws('_',lead_id,58)
WHEN notes ilike '%44058%' THEN concat_ws('_',lead_id,59)
WHEN notes ilike '%44030%' THEN concat_ws('_',lead_id,60)
WHEN notes ilike '%buyer falls outside%' THEN concat_ws('_',lead_id,61)
WHEN (notes ilike '%card data security%' OR notes ilike '%security breach%' OR notes ilike '%+Security+violation%') THEN concat_ws('_',lead_id,62)
WHEN notes ilike '%Restrictions for the customer card%' THEN concat_ws('_',lead_id,63)
WHEN notes ilike '%General+decline+of+the+card%' THEN concat_ws('_',lead_id,64)
WHEN notes ilike '%+Inactive+card+or+card%' THEN concat_ws('_',lead_id,65)
WHEN notes ilike '%rejected+by+Decision+Manager%' THEN concat_ws('_',lead_id,66)
WHEN notes ilike '%deserted%' THEN concat_ws('_',lead_id,67)
WHEN notes ilike '%45030%' THEN concat_ws('_',lead_id,68)
WHEN notes ilike '%FIN012%' THEN concat_ws('_',lead_id,69)
WHEN notes ilike '%REJECTED_BY_THIRD%' THEN concat_ws('_',lead_id,70)
WHEN notes ilike '%42102%' THEN concat_ws('_',lead_id,71)
WHEN notes ilike '%lost_card%' THEN concat_ws('_',lead_id,72)
WHEN notes ilike '%800.100.161%' THEN concat_ws('_',lead_id,73)
WHEN notes ilike '%800.100.166%' THEN concat_ws('_',lead_id,74)
WHEN notes ilike '%invalid_pin%' THEN concat_ws('_',lead_id,74)
WHEN notes ilike '%800.100.190%' THEN concat_ws('_',lead_id,75)
WHEN notes ilike '%100.100.401%' THEN concat_ws('_',lead_id,30)
WHEN notes ilike '%new_card_not_unblocked%' THEN concat_ws('_',lead_id,76)
ELSE concat_ws('_',lead_id,77)
END AS lead_reason,
CASE 
WHEN psp IN ('AccentPay','Accetpayac') THEN 'Accentpay'
WHEN psp IN ('Alimpay','Alumpay', 'AliumPay', 'Bank Transfer PIX_Alium', 'Bank_Transfer PIX_Alium', 'Bank Transfer PIX_AliumPay') THEN 'Aliumpay'
WHEN psp IN ('Ffibonatix', 'Fibinatix', 'fibo', 'Fiboantix', 'Fiboatix', 'Fibonaitx', 'Fibonati', 'fibonatix', '	 Fibonatix', 'Fibonatix.', 'FIbonatix', 'Fibonatix A', 'Fibonatixc', 
'Fibonatix	Fibonatix', 'Fibonatix-R','Fibotanix','Finatix') THEN 'Fibonatix'
WHEN psp IN ('wire', 'FTD_Wire','WirePN') THEN 'Wisewire'
ELSE psp
END as psp_name,
p.id as psp_id,
cast(case when ml.hidden is false and ml.is_fake is false and ml.unhidden_date is not null and ml.ftd_date>ml.unhidden_date then ml.unhidden_date
  else ml.ftd_date end as date) as ftd_day,
CURRENT_TIMESTAMP AS current_datetime
    FROM 
        public_brm.sales_transactions_transformed st
LEFT JOIN public_brm.marketing_leads ml ON ml.sales_lead_id=st.lead_id
LEFT JOIN public_brm.psps p on p.name= CASE 
WHEN psp IN ('AccentPay','Accetpayac') THEN 'Accentpay'
WHEN psp IN ('Alimpay','Alumpay', 'AliumPay', 'Bank Transfer PIX_Alium', 'Bank_Transfer PIX_Alium', 'Bank Transfer PIX_AliumPay') THEN 'Aliumpay'
WHEN psp IN ('Ffibonatix', 'Fibinatix', 'fibo', 'Fiboantix', 'Fiboatix', 'Fibonaitx', 'Fibonati', 'fibonatix', '	 Fibonatix', 'Fibonatix.', 'FIbonatix', 'Fibonatix A', 'Fibonatixc', 
'Fibonatix	Fibonatix', 'Fibonatix-R','Fibotanix','Finatix') THEN 'Fibonatix'
WHEN psp IN ('wire', 'FTD_Wire','WirePN') THEN 'Wisewire'
ELSE psp END
    WHERE
        status in ('Approved','Rejected')
        AND type = 'Deposit'
        AND psp NOT IN ('test', 'Test')