SELECT 
    dialer_name_language, 
    dialer_language
FROM (VALUES
    ('C17 - EN', 'EN'),
    ('C2 - TR/AZ', 'TR/AZ'),
    ('C2 - RU', 'RU'),
    ('CB10 - BR1', 'BR1'),
    ('CB9 - BR2', 'BR2'),
    ('CB9 - ITL', 'ITL'),
    ('C4 - FR', 'FR'),
    ('C6 - TH', 'TH'),
    ('Unknown', 'Unknown')
) AS dialer_languages(dialer_name_language, dialer_language)