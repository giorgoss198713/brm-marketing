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
ELSE 'Unspecified Reason'
END AS decline_reason,
CASE 
WHEN psp IN ('AccentPay','Accetpayac') THEN 'Accentpay'
WHEN psp IN ('Alimpay','Alumpay', 'AliumPay', 'Bank Transfer PIX_Alium', 'Bank_Transfer PIX_Alium', 'Bank Transfer PIX_AliumPay') THEN 'Aliumpay'
WHEN psp IN ('Ffibonatix', 'Fibinatix', 'fibo', 'Fiboantix', 'Fiboatix', 'Fibonaitx', 'Fibonati', 'fibonatix', '	 Fibonatix', 'Fibonatix.', 'FIbonatix', 'Fibonatix A', 'Fibonatixc', 
'Fibonatix	Fibonatix', 'Fibonatix-R','Fibotanix','Finatix') THEN 'Fibonatix'
WHEN psp IN ('wire', 'FTD_Wire','WirePN') THEN 'Wisewire'
ELSE psp
END as psp_name,
p.id as psp_id,
cast(ml.ftd_date as date) as ftd_day,
CURRENT_TIMESTAMP AS current_datetime
    FROM 
        public_brm.sales_transactions st
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