from dealflow_ai_engine.api.schemas.common import StrategyResponse


def validate_strategy(strategy: StrategyResponse) -> list[str]:
    issues: list[str] = []
    if not strategy.evidence:
        issues.append("strategy must include at least one evidence item")
    if not strategy.recommended_actions:
        issues.append("strategy must include at least one recommended action")
    if strategy.priority not in {"high", "medium", "low"}:
        issues.append("priority must be one of high, medium, low")
    return issues
