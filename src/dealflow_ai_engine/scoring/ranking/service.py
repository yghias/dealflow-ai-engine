from dealflow_ai_engine.api.schemas.common import RankedSignal, SignalPayload
from dealflow_ai_engine.entities.enrichment.enricher import enrich_organization
from dealflow_ai_engine.entities.extraction.simple_extractors import extract_organization_name
from dealflow_ai_engine.entities.resolution.resolver import resolve_organization
from dealflow_ai_engine.scoring.features.feature_builder import build_features
from dealflow_ai_engine.scoring.rules.weighted_score import calculate_weighted_score


def rank_signal(signal: SignalPayload) -> RankedSignal:
    organization_name = extract_organization_name(signal)
    resolved = resolve_organization(organization_name)
    enrichment = enrich_organization(organization_name=resolved.canonical_name, signal_type=signal.signal_type)
    features = build_features(signal=signal, resolved=resolved, enrichment=enrichment)
    score, rationale = calculate_weighted_score(features)
    return RankedSignal(
        organization_name=resolved.canonical_name,
        signal_type=signal.signal_type,
        score=score,
        rationale=rationale,
    )
