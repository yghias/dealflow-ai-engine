from dealflow_ai_engine.ingestion.connectors.mock_signals import fetch_mock_signals
from dealflow_ai_engine.scoring.ranking.service import rank_signal


def test_rank_signal_returns_positive_score() -> None:
    signal = fetch_mock_signals()[0]
    ranked = rank_signal(signal)
    assert ranked.organization_name == "Acme Data Systems"
    assert ranked.score == 0.9025
    assert ranked.rationale
    assert ranked.owner_name == "Detroit Software Coverage"
