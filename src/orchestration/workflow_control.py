def should_dispatch_to_crm(priority_score: float, crm_writeback_enabled: bool) -> bool:
    return crm_writeback_enabled and priority_score >= 0.8
