from dataclasses import dataclass
from datetime import datetime
from uuid import UUID


@dataclass(slots=True)
class SignalEventRecord:
    signal_id: UUID
    source_system: str
    signal_type: str
    organization_name: str
    detected_at: datetime
    summary: str


@dataclass(slots=True)
class StrategyRecommendationRecord:
    recommendation_id: UUID
    signal_id: UUID
    priority: str
    owner_hint: str
    created_at: datetime
