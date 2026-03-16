from datetime import datetime, timezone

from src.common.contracts import validate_signal_contract


def fetch_company_signals() -> list[dict]:
    signals = [
        {
            "source_record_id": "sig_001",
            "source_system": "funding_feed",
            "event_type": "funding_announcement",
            "company_name": "North Ridge Systems",
            "event_timestamp": datetime(2026, 3, 16, 10, 30, tzinfo=timezone.utc).isoformat(),
            "website": "https://northridgesystems.com",
            "sector": "Enterprise Software",
            "employee_count": 220,
            "funding_round": "Series B",
            "funding_amount_usd": 40000000,
            "investor_name": "Summit Peak Ventures",
        }
    ]
    for signal in signals:
        issues = validate_signal_contract(signal)
        if issues:
            raise ValueError(f"signal contract validation failed: {issues}")
    return signals
