from dataclasses import dataclass


@dataclass(slots=True)
class ResolvedOrganization:
    canonical_name: str
    crm_account_id: str | None
    confidence: float


def resolve_organization(name: str) -> ResolvedOrganization:
    """Simple deterministic matcher suitable for local examples."""
    normalized = name.strip().lower()
    crm_account_id = "acct_acme_001" if normalized == "acme data systems" else None
    confidence = 0.97 if crm_account_id else 0.72
    return ResolvedOrganization(canonical_name=name.strip(), crm_account_id=crm_account_id, confidence=confidence)
