insert into raw.external_signal_event (batch_id, source_system, source_record_id, payload)
select
    'seed_batch_001',
    'mock_news_feed',
    'signal_acme_001',
    parse_json('{
        "source": "mock_news_feed",
        "title": "Acme Data Systems announces Midwest expansion",
        "url": "https://example.com/acme-expansion",
        "signal_type": "expansion",
        "summary": "Acme Data Systems is opening a new Detroit office and hiring enterprise sales staff.",
        "detected_at": "2026-03-15T12:00:00Z",
        "metadata": {"organization_name": "Acme Data Systems"}
    }');
