from src.ingestion.api_ingest import fetch_company_signals


def test_fetch_company_signals_returns_records() -> None:
    records = fetch_company_signals()
    assert records
    assert records[0]["company_name"] == "North Ridge Systems"
