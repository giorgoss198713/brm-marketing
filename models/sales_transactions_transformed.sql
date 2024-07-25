SELECT * 
FROM public_brm.sales_transactions
WHERE
(notes NOT iLIKE '%Redeposit%' OR notes IS NULL)