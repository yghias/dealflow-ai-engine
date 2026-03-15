from dealflow_ai_engine.api.schemas.common import StrategyRequest, StrategyResponse


def generate_strategy(request: StrategyRequest) -> StrategyResponse:
    ranked = request.ranked_signal
    actions = [
        f"Create a CRM task for the coverage owner to review {ranked.organization_name}.",
        f"Draft a tailored outreach sequence referencing the {ranked.signal_type} signal.",
        "Queue a light enrichment refresh before first contact.",
    ]
    risks = [
        "Signal may already be known to the coverage team.",
        "Counterparty timing may not align with current investment or partnership cycle.",
    ]
    evidence = ranked.rationale + [f"Ranked score: {ranked.score:.2f}."]
    return StrategyResponse(
        priority="high" if ranked.score >= 0.8 else "medium",
        opportunity_summary=(
            f"{ranked.organization_name} appears to be entering a relevant inflection point "
            f"based on a recent {ranked.signal_type} signal."
        ),
        why_now="The signal is fresh, the fit score is strong, and the account is actionable.",
        recommended_actions=actions,
        risks=risks,
        evidence=evidence,
        owner_hint=request.crm_context.get("owner_hint", "sector_coverage_queue"),
    )
