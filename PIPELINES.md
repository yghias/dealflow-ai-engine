# Pipelines

## Pipeline Groups

### Signal Landing
- Python connectors extract data from external APIs, files, and CRM systems.
- Raw payloads are loaded into Snowflake with batch ids and source watermarks.
- Connector state is stored separately from transformation logic to preserve replayability.

### Warehouse Transformation
- Staging models standardize ids, timestamps, enumerations, and payload structure.
- Intermediate models perform company resolution, CRM matching, score input assembly, and outcome attribution.
- Marts publish ranked work queues, source quality datasets, and recommendation effectiveness reporting.

### Strategy Generation
- Airflow reads the ranked queue mart and submits strategy requests for approved cohorts.
- The AI service only consumes curated datasets, not source payloads.
- Generated recommendations are validated and written back with prompt and model metadata.

### CRM Dispatch
- Approved recommendations are converted into deterministic task payloads.
- CRM writeback is replay-safe and can be disabled without stopping ranking refresh.

## Airflow DAG Layout
```mermaid
flowchart LR
    A["extract_external_signals"] --> B["load_raw_signals"]
    B --> C["run_staging_models"]
    C --> D["run_intermediate_models"]
    D --> E["publish_ranked_queue_marts"]
    E --> F["generate_strategies"]
    F --> G["dispatch_crm_tasks"]
    G --> H["load_crm_outcomes"]
    H --> I["refresh_effectiveness_marts"]
    I --> J["run_data_quality_and_reconciliation"]
```

## Scheduling and SLAs
- High-value external sources: every 30 minutes.
- CRM extract sync: every 15 minutes when supported.
- Warehouse transformation DAG: hourly.
- Recommendation generation for high-priority signals: every 30 minutes.
- Nightly attribution and performance refresh: complete by 06:00 warehouse local time.

## Idempotency
- Raw loads keyed on source system, source record id, and ingestion batch id.
- Curated models deduplicate by latest valid record per business key.
- CRM tasks use deterministic task keys to prevent duplicate downstream actions.
