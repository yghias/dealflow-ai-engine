from datetime import datetime
from typing import Any
from uuid import UUID, uuid4

from pydantic import BaseModel, Field


class TimestampedModel(BaseModel):
    created_at: datetime = Field(default_factory=datetime.utcnow)


class SignalPayload(BaseModel):
    title: str
    source: str
    url: str
    detected_at: datetime
    signal_type: str
    summary: str
    metadata: dict[str, Any] = Field(default_factory=dict)


class RankedSignal(BaseModel):
    signal_id: UUID = Field(default_factory=uuid4)
    organization_name: str
    signal_type: str
    score: float
    rationale: list[str]


class StrategyRequest(BaseModel):
    ranked_signal: RankedSignal
    crm_context: dict[str, Any] = Field(default_factory=dict)


class StrategyResponse(TimestampedModel):
    recommendation_id: UUID = Field(default_factory=uuid4)
    priority: str
    opportunity_summary: str
    why_now: str
    recommended_actions: list[str]
    risks: list[str]
    evidence: list[str]
    owner_hint: str


class HealthResponse(BaseModel):
    status: str
    environment: str
    dependencies: dict[str, str]
