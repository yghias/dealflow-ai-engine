from dealflow_ai_engine.api.schemas.common import RankedSignal, SignalPayload
from dealflow_ai_engine.analytics.warehouse import FixtureWarehouse
from dealflow_ai_engine.entities.extraction.simple_extractors import extract_organization_name
from dealflow_ai_engine.entities.resolution.resolver import resolve_organization


def rank_signal(signal: SignalPayload) -> RankedSignal:
    organization_name = extract_organization_name(signal)
    resolved = resolve_organization(organization_name)
    warehouse = FixtureWarehouse()
    queue = warehouse.read_ranked_queue()
    selected = next(
        (item for item in queue if item["organization_name"].lower() == resolved.canonical_name.lower()),
        None,
    )
    if selected:
        return RankedSignal(**selected)
    return RankedSignal(
        organization_name=resolved.canonical_name,
        signal_type=signal.signal_type,
        score=round((resolved.confidence * 0.4) + 0.4, 4),
        rationale=[
            "Local fallback path used because the signal is not present in the curated ranked queue fixture.",
            f"Entity resolution confidence is {resolved.confidence:.2f}.",
            "Authoritative score logic lives in the warehouse models under models/intermediate and models/marts.",
        ],
        owner_name="unassigned_queue",
    )
