from dataclasses import dataclass, field


@dataclass(slots=True)
class EnrichmentSnapshot:
    organization_name: str
    industry: str
    employee_band: str
    region: str
    signals: list[str] = field(default_factory=list)


def enrich_organization(organization_name: str, signal_type: str) -> EnrichmentSnapshot:
    default_region = "North America"
    return EnrichmentSnapshot(
        organization_name=organization_name,
        industry="B2B Software",
        employee_band="201-500",
        region=default_region,
        signals=[signal_type],
    )
