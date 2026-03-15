from dealflow_ai_engine.ingestion.connectors.mock_signals import fetch_mock_signals
from dealflow_ai_engine.orchestration.tasks.workflow import process_signal


def test_process_signal_end_to_end() -> None:
    result = process_signal(fetch_mock_signals()[0])
    assert result["dispatch"]["status"] == "queued"
    assert result["strategy"]["recommended_actions"]
