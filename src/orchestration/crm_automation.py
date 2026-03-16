def dispatch_crm_workflows() -> list[dict]:
    return [
        {
            "workflow_id": "crmwf_001",
            "deal_id": "deal_001",
            "action": "create_task",
            "owner_name": "Growth Equity Coverage",
            "status": "queued",
        }
    ]
