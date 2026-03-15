from dealflow_ai_engine.api.schemas.common import StrategyResponse
from dealflow_ai_engine.crm.adapters.base import CRMTaskPayload
from dealflow_ai_engine.crm.adapters.mock import MockCRMAdapter


def dispatch_strategy(strategy: StrategyResponse, organization_name: str) -> dict[str, str]:
    adapter = MockCRMAdapter()
    task_id = adapter.create_task(
        CRMTaskPayload(
            account_name=organization_name,
            priority=strategy.priority,
            summary=strategy.opportunity_summary,
            owner_hint=strategy.owner_hint,
        )
    )
    return {"task_id": task_id, "status": "queued"}
