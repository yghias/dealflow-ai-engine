# Observability

## Pillars
- Logs: structured JSON logs with run IDs, entity IDs, and external IDs.
- Metrics: ingestion freshness, pipeline latency, error rates, model cost, and business conversion.
- Traces: correlated flows across ingestion, scoring, generation, and CRM writeback.
- Audits: explanation views for why a recommendation or task was created.

## Key Monitors
- Connector freshness lag by source.
- Duplicate signal rate spikes.
- Entity match confidence distribution shifts.
- Strategy generation schema failure rate.
- CRM sync error count and retry backlog.
- Daily model spend and latency percentiles.

## Operational Dashboards
- Pipeline operations dashboard.
- Source health dashboard.
- AI performance dashboard.
- Funnel and conversion dashboard.
