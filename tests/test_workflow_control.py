from src.orchestration.workflow_control import should_dispatch_to_crm


def test_should_dispatch_to_crm_when_high_priority_and_enabled() -> None:
    assert should_dispatch_to_crm(0.82, True) is True
