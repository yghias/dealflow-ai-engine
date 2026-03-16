# dealflow-ai-engine Implementation Plan

## Planning Scope
This document captures the implementation plan for the platform repository. It focuses on warehouse-first modeling, Airflow-managed orchestration, external signal ingestion, CRM automation, and AI-assisted strategy generation.

## Delivery Themes
- Snowflake as the system of curated truth.
- SQL-owned transformations, marts, tests, and KPI logic.
- Python reserved for ingestion, orchestration, adapters, and utility execution paths.
- Explicit governance, observability, and replay-safe workflow handling.

## Delivery Phases

### Phase 1
- Establish raw landing contracts, Snowflake schemas, and warehouse models.
- Land core external signal and CRM extracts.
- Publish ranked queue, owner worklist, and source quality marts.

### Phase 2
- Add AI strategy request datasets and recommendation storage.
- Introduce CRM dispatch jobs with deterministic idempotency keys.
- Add attribution marts for recommendation effectiveness and pipeline conversion.

### Phase 3
- Expand source coverage, relationship intelligence, and recommendation evaluation.
- Harden deployment, monitoring, and operational controls across environments.
