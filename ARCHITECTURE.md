# Architecture

## System Context
`dealflow-ai-engine` sits between external signal sources, internal CRM systems, and downstream analytics. It behaves as both an intelligence platform and an operational automation layer.

```mermaid
flowchart TB
    subgraph Sources
        S1["News / PR APIs"]
        S2["Job Posting Feeds"]
        S3["Web / Blogs"]
        S4["Filings / Transcripts"]
        S5["CRM Activity"]
        S6["Manual Uploads"]
    end

    subgraph Platform
        P1["Ingestion Layer"]
        P2["Entity + Enrichment Layer"]
        P3["Scoring Layer"]
        P4["AI Strategy Engine"]
        P5["Orchestration Layer"]
        P6["Analytics + Feedback"]
        P7["Optional Graph Layer"]
    end

    subgraph Systems
        T1["Postgres"]
        T2["CRM"]
        T3["Slack / Email"]
        T4["BI / Dashboards"]
    end

    Sources --> P1
    P1 --> P2
    P2 --> P3
    P3 --> P4
    P4 --> P5
    P5 --> T2
    P5 --> T3
    T2 --> P6
    P6 --> T4
    P6 --> P3
    P6 --> P4
    P2 --> P7
    P7 --> P4
    Platform --> T1
```

## Component Responsibilities

### Ingestion Layer
- Connector adapters per source.
- Incremental extraction and checkpoint storage.
- Raw payload retention.
- Canonical signal normalization and deduplication.

### Entity and Enrichment Layer
- NLP extraction from unstructured signals.
- Match and merge against canonical organizations and people.
- CRM crosswalk management.
- External enrichment snapshots with provenance.

### Scoring Layer
- Feature computation from signals, enrichment, CRM state, and prior outcomes.
- Weighted rules-based ranking first.
- Upgrade path to learning-to-rank or classification models.

### AI Strategy Engine
- Prompt orchestration with structured response contracts.
- Retrieval of playbooks, examples, and prior winning patterns.
- Validation and confidence routing.

### Orchestration Layer
- Task creation and routing.
- SLA and retry policies.
- Integration event delivery to CRM, Slack, and review queues.

### Analytics and Feedback
- Outcome attribution.
- Funnel performance and source quality.
- AI and ranking evaluation dashboards.
- Prompt/model drift and acceptance metrics.

### Optional Graph Layer
- Relationship search for warm intro paths, board overlap, and portfolio adjacency.
- Graph projection from canonical entities and role mappings.

## Key Architecture Decisions
- Postgres is the canonical operational store.
- External systems are accessed through isolated adapters.
- AI output is structured JSON first, narrative second.
- Every recommendation is tied to features, evidence, prompt version, and model run metadata.
- Human review is built into low-confidence resolution and strategy workflows.

## Runtime Boundaries

```mermaid
sequenceDiagram
    participant Source as External Source
    participant Ingest as Ingestion Job
    participant Core as Postgres Core
    participant Score as Scoring Service
    participant LLM as Strategy Engine
    participant Orchestrator as Task Orchestrator
    participant CRM as CRM

    Source->>Ingest: New signal payload
    Ingest->>Core: raw_document + signal_event
    Ingest->>Core: extracted entities
    Score->>Core: feature_snapshot + score_result
    LLM->>Core: strategy_recommendation + model_run
    Orchestrator->>CRM: create task/note
    CRM->>Core: outcome_event and sync state
```

## Non-Functional Requirements
- Idempotent ingestion and sync jobs.
- Full provenance for externally sourced facts.
- Observable end-to-end flows with run IDs and correlation IDs.
- Configurable cost controls for model usage.
- Environment-aware deployment with promotion gates.
