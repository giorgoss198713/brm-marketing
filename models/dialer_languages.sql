    select 
    id,
    service_name,
    CASE WHEN service_name='C17' THEN 'EN'
    WHEN service_name='C2' THEN 'RU'
    WHEN service_name='C4' THEN 'FR'
    WHEN service_name='C6' THEN 'TH'
    WHEN service_name='CB10' THEN 'BR1'
    WHEN service_name='CB9' THEN 'BR2'
    ELSE 'TR/AZ' END AS language
    FROM public_brm.external_apis