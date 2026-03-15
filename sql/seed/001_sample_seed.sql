insert into core.source_system (source_system_id, source_name, source_type)
values
    ('00000000-0000-0000-0000-000000000001', 'mock_news_feed', 'news'),
    ('00000000-0000-0000-0000-000000000002', 'mock_funding_feed', 'funding')
on conflict (source_name) do nothing;
