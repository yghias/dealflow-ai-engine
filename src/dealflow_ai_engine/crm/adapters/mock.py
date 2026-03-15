from dealflow_ai_engine.crm.adapters.base import CRMAdapter, CRMTaskPayload


class MockCRMAdapter(CRMAdapter):
    def create_task(self, payload: CRMTaskPayload) -> str:
        return f"mock-task::{payload.account_name.lower().replace(' ', '_')}"
