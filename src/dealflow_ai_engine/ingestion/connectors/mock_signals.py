from datetime import datetime, timezone

from dealflow_ai_engine.api.schemas.common import SignalPayload


def fetch_mock_signals() -> list[SignalPayload]:
    """Return deterministic sample signals for local development and tests."""
    return [
        SignalPayload(
            title="Acme Data Systems announces Midwest expansion",
            source="mock_news_feed",
            url="https://example.com/acme-expansion",
            detected_at=datetime(2026, 3, 15, 12, 0, tzinfo=timezone.utc),
            signal_type="expansion",
            summary="Acme Data Systems is opening a new Detroit office and hiring enterprise sales staff.",
            metadata={"organization_name": "Acme Data Systems", "region": "Midwest"},
        ),
        SignalPayload(
            title="BrightForge secures Series B funding",
            source="mock_funding_feed",
            url="https://example.com/brightforge-series-b",
            detected_at=datetime(2026, 3, 15, 13, 0, tzinfo=timezone.utc),
            signal_type="funding",
            summary="BrightForge raised $55M to accelerate go-to-market expansion.",
            metadata={"organization_name": "BrightForge", "round": "Series B", "amount_usd": 55000000},
        ),
    ]
