# Observability

## Service-Level Indicators
- Source freshness lag by connector.
- Airflow DAG success rate and runtime.
- Warehouse model runtime and failure counts.
- Ranked queue publication latency.
- CRM task dispatch success and replay backlog.
- Recommendation schema validation pass rate.

## Logging
- Python services emit structured logs with `run_id`, `source_system`, `external_id`, and `warehouse_batch_id`.
- Connector retries and downstream writebacks emit attempt counts and terminal state.

## Monitoring
- Airflow alerts for missed SLAs and repeated retries.
- Warehouse test failures page the owning pipeline team.
- Queue drops, score anomalies, and CRM writeback failures trigger operational alerts.
