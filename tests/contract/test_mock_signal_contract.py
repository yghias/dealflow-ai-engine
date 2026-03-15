from dealflow_ai_engine.ingestion.connectors.mock_signals import fetch_mock_signals


def test_mock_signals_have_required_fields() -> None:
    for signal in fetch_mock_signals():
        assert signal.title
        assert signal.url.startswith("https://")
        assert signal.signal_type
