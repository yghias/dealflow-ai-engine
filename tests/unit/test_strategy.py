from dealflow_ai_engine.api.schemas.common import StrategyRequest
from dealflow_ai_engine.ingestion.connectors.mock_signals import fetch_mock_signals
from dealflow_ai_engine.quality.validation.strategy_validator import validate_strategy
from dealflow_ai_engine.scoring.ranking.service import rank_signal
from dealflow_ai_engine.strategy.generation.service import generate_strategy


def test_generate_strategy_is_valid() -> None:
    ranked = rank_signal(fetch_mock_signals()[0])
    strategy = generate_strategy(StrategyRequest(ranked_signal=ranked, crm_context={}))
    assert validate_strategy(strategy) == []
    assert strategy.priority in {"high", "medium"}
