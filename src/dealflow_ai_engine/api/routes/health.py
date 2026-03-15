from fastapi import APIRouter

from dealflow_ai_engine.api.schemas.common import HealthResponse
from dealflow_ai_engine.config.settings import get_settings

router = APIRouter(tags=["health"])


@router.get("/health", response_model=HealthResponse)
def healthcheck() -> HealthResponse:
    settings = get_settings()
    return HealthResponse(
        status="ok",
        environment=settings.app_env,
        dependencies={"postgres": "configured", "crm": settings.crm_provider},
    )
