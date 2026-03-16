# Pipelines

## Pipeline Structure
The platform uses a layered pipeline:

`raw -> staging -> transformations -> marts`

## Pipeline Families
- Signal ingestion
- Company and investor enrichment
- Entity matching and normalization
- Deal and investor scoring
- AI strategy generation
- CRM lifecycle automation
- Outcome tracking and feedback

## Airflow Workflow Sequence
```mermaid
flowchart LR
    A["signal_ingestion"] --> B["staging_models"]
    B --> C["entity_resolution"]
    C --> D["enrichment_merge"]
    D --> E["scoring_models"]
    E --> F["strategy_generation"]
    F --> G["crm_automation"]
    G --> H["outcome_tracking"]
```

## Idempotency
- Raw loads keyed by source system and source record id
- Staging deduplication by source id plus event timestamp
- CRM automation keyed by deterministic workflow id
- Backfills rerun safely by date range and source
