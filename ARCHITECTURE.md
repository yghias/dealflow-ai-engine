# Architecture

## System Context
`dealflow-ai-engine` is a warehouse-centric platform for signal ingestion, enrichment, ranking, strategy preparation, CRM workflow automation, and outcome measurement. Snowflake holds the curated operating state, Airflow coordinates ingestion and transformation runs, and Python services provide connector logic, orchestration helpers, and tightly scoped APIs.

```mermaid
flowchart TB
    subgraph Sources
        S1["News, PR, Market Data"]
        S2["Hiring and Job Feeds"]
        S3["CRM Extracts"]
        S4["Company Websites"]
        S5["Filings and Transcript Sources"]
        S6["Manual Analyst Uploads"]
    end

    subgraph Execution
        E1["Python Connectors"]
        E2["Airflow DAGs"]
        E3["API Control Plane"]
    end

    subgraph Warehouse
        W1["Snowflake Raw"]
        W2["Snowflake Staging"]
        W3["Intermediate Models"]
        W4["Marts and Semantic Datasets"]
    end

    subgraph Consumers
        C1["AI Strategy Service"]
        C2["CRM Writeback"]
        C3["Operational Dashboards"]
        C4["Coverage Queues"]
    end

    Sources --> E1
    E1 --> W1
    E2 --> W2
    W2 --> W3
    W3 --> W4
    W4 --> C1
    W4 --> C3
    W4 --> C4
    C1 --> C2
    C2 --> W1
    E3 --> C2
```

## Service Boundaries

### Python Layer
- External source connectors and payload loaders.
- Airflow DAG definitions and execution wrappers.
- API endpoints for health, fixture-driven smoke tests, and controlled workflow runs.
- CRM adapter implementations and idempotent writeback helpers.

### Warehouse Layer
- Source-normalized staging models.
- Entity resolution and scoring input models.
- Ranked queue, owner worklist, source quality, and outcome marts.
- Data quality tests and reconciliation queries.

### AI Layer
- Prompt catalog and request/response schemas.
- Strategy request dataset generation from warehouse marts.
- Recommendation storage and feedback capture.

## Architecture Decisions
- Snowflake is the source of curated truth for ranked queues, strategy requests, and platform metrics.
- SQL models own score assembly, prioritization inputs, KPI definitions, and reporting logic.
- Python avoids heavy business transformation logic and instead orchestrates loads, triggers, and integrations.
- CRM writeback is isolated from warehouse scoring to prevent source outages from blocking ranking refreshes.

## Execution Flow
```mermaid
sequenceDiagram
    participant Source as Source
    participant Connector as Python Connector
    participant Snowflake as Snowflake
    participant Airflow as Airflow
    participant SQL as SQL Models
    participant AI as AI Strategy Service
    participant CRM as CRM Adapter

    Source->>Connector: incremental payloads
    Connector->>Snowflake: raw load batch
    Airflow->>SQL: staging + intermediate + marts
    SQL->>AI: strategy request dataset
    AI->>CRM: task or note payload
    CRM->>Snowflake: activity and outcome snapshot
    Airflow->>SQL: attribution and effectiveness refresh
```

## Non-Functional Requirements
- Idempotent loads using source watermarks and deterministic merge keys.
- Environment separation across development, staging, and production Snowflake objects and Airflow connections.
- Warehouse tests required before queue publication and CRM writeback.
- Full traceability from raw signal to ranked queue, strategy recommendation, and CRM outcome.
