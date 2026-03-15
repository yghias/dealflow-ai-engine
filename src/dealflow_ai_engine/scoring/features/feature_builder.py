from dataclasses import dataclass

from dealflow_ai_engine.api.schemas.common import SignalPayload
from dealflow_ai_engine.entities.enrichment.enricher import EnrichmentSnapshot
from dealflow_ai_engine.entities.resolution.resolver import ResolvedOrganization


@dataclass(slots=True)
class FeatureSnapshot:
    organization_name: str
    signal_type: str
    recency_score: float
    crm_match_score: float
    fit_score: float
    evidence_score: float


def build_features(
    signal: SignalPayload,
    resolved: ResolvedOrganization,
    enrichment: EnrichmentSnapshot,
) -> FeatureSnapshot:
    return FeatureSnapshot(
        organization_name=enrichment.organization_name,
        signal_type=signal.signal_type,
        recency_score=0.9,
        crm_match_score=resolved.confidence,
        fit_score=0.82 if enrichment.industry == "B2B Software" else 0.5,
        evidence_score=0.88 if signal.summary else 0.3,
    )
