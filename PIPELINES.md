# Pipelines

## Pipeline Families

### 1. Signal Ingestion
- Extract from external APIs, feeds, and internal activity sources.
- Store immutable payloads in raw storage.
- Normalize into canonical signal records.
- Deduplicate and tag signal types.

### 2. Entity Resolution and Enrichment
- Parse text and identify entities.
- Resolve against canonical records and CRM mappings.
- Enrich matched records with provider data.
- Store snapshots and resolution confidence.

### 3. Scoring and Ranking
- Build features from signal, entity, and CRM context.
- Apply rules-based ranking with explainable components.
- Publish review queues and candidate opportunities.

### 4. Strategy Generation
- Retrieve relevant context and prior examples.
- Run prompt-based strategy generation.
- Validate structured output and confidence thresholds.

### 5. Task Orchestration
- Route work to owners and systems.
- Push tasks to CRM, Slack, or analyst queues.
- Track execution attempts and state transitions.

### 6. Outcome and Evaluation
- Sync downstream CRM activity.
- Attribute results to signals, scores, and strategy versions.
- Update dashboards and benchmark sets.

## Example Airflow DAG Layout
```mermaid
flowchart LR
    A["extract_signals"] --> B["normalize_signals"]
    B --> C["resolve_entities"]
    C --> D["run_enrichment"]
    D --> E["build_features"]
    E --> F["score_opportunities"]
    F --> G["generate_strategies"]
    G --> H["create_tasks"]
    H --> I["sync_crm_outcomes"]
    I --> J["refresh_analytics_marts"]
```

## Idempotency Rules
- Use source-native event IDs when available.
- Otherwise hash on normalized URL, title, event time, and source.
- Upserts must be deterministic on unique business keys.
- Prompt generation should persist request keys to avoid duplicate recommendations.
- CRM writes should include client-generated idempotency keys.

## Data Contracts
- Each pipeline stage must emit explicit success and failure counters.
- Each table load must include `run_id`, `processed_at`, and `record_source`.
- Schema contracts should be validated before promotion to later stages.
