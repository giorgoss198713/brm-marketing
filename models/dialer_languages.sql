SELECT 
    id,
    dialer_name_language, 
    dialer_language
FROM (VALUES
    (30,'C17 - EN', 'EN'),
    (37,'C2 - TR/AZ', 'TR/AZ'),
    (37,'C2 - RU', 'RU'),
    (3,'CB10 - BR1', 'BR1'),
    (5,'CB9 - BR2', 'BR2'),
    (5,'CB9 - ITL', 'ITL'),
    (7,'C4 - FR', 'FR'),
    (17,'C6 - TH', 'TH'),
    (0,'Unknown', 'Unknown')
) AS dialer_languages(id,dialer_name_language, dialer_language)