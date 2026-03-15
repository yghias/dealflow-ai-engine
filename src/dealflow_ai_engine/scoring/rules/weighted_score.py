from dealflow_ai_engine.scoring.features.feature_builder import FeatureSnapshot


WEIGHTS = {
    "recency_score": 0.30,
    "crm_match_score": 0.25,
    "fit_score": 0.30,
    "evidence_score": 0.15,
}


def calculate_weighted_score(features: FeatureSnapshot) -> tuple[float, list[str]]:
    score = (
        features.recency_score * WEIGHTS["recency_score"]
        + features.crm_match_score * WEIGHTS["crm_match_score"]
        + features.fit_score * WEIGHTS["fit_score"]
        + features.evidence_score * WEIGHTS["evidence_score"]
    )
    rationale = [
        f"Signal type '{features.signal_type}' is recent and still actionable.",
        f"CRM/entity resolution confidence is {features.crm_match_score:.2f}.",
        f"Strategic fit score is {features.fit_score:.2f} based on sector alignment.",
    ]
    return round(score, 4), rationale
