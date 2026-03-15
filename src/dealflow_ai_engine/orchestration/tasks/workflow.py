from dealflow_ai_engine.api.schemas.common import SignalPayload, StrategyRequest
from dealflow_ai_engine.crm.sync.service import dispatch_strategy
from dealflow_ai_engine.scoring.ranking.service import rank_signal
from dealflow_ai_engine.strategy.generation.service import generate_strategy


def process_signal(signal: SignalPayload) -> dict[str, object]:
    ranked = rank_signal(signal)
    strategy = generate_strategy(StrategyRequest(ranked_signal=ranked, crm_context={}))
    dispatch = dispatch_strategy(strategy=strategy, organization_name=ranked.organization_name)
    return {
        "ranked_signal": ranked.model_dump(),
        "strategy": strategy.model_dump(),
        "dispatch": dispatch,
    }
