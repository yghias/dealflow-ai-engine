from fastapi import APIRouter, FastAPI

from dealflow_ai_engine.api.routes.health import router as health_router
from dealflow_ai_engine.api.schemas.common import RankedSignal, SignalPayload, StrategyRequest, StrategyResponse
from dealflow_ai_engine.config.logging import configure_logging
from dealflow_ai_engine.config.settings import get_settings
from dealflow_ai_engine.ingestion.connectors.mock_signals import fetch_mock_signals
from dealflow_ai_engine.orchestration.tasks.workflow import process_signal
from dealflow_ai_engine.scoring.ranking.service import rank_signal
from dealflow_ai_engine.strategy.generation.service import generate_strategy


settings = get_settings()
configure_logging(settings.log_level)

app = FastAPI(title="dealflow-ai-engine", version="0.1.0")
app.include_router(health_router)

router = APIRouter(tags=["workflow"])


@router.get("/signals/mock", response_model=list[SignalPayload])
def list_mock_signals() -> list[SignalPayload]:
    return fetch_mock_signals()


@router.post("/signals/rank", response_model=RankedSignal)
def rank_signal_endpoint(payload: SignalPayload) -> RankedSignal:
    return rank_signal(payload)


@router.post("/strategies/generate", response_model=StrategyResponse)
def generate_strategy_endpoint(request: StrategyRequest) -> StrategyResponse:
    return generate_strategy(request)


@router.post("/workflow/process")
def process_signal_endpoint(payload: SignalPayload) -> dict[str, object]:
    return process_signal(payload)


app.include_router(router)
