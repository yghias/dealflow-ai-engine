# Runbook

## Local Development
1. Start local services with `docker compose up -d`.
2. Install dependencies with `pip install -r requirements.txt`.
3. Populate `.env` from `.env.example`.
4. Run the API with `uvicorn dealflow_ai_engine.api.app:app --reload`.
5. Execute validation with `pytest`.

## Common Operations

### Backfill Source Window
- Run the Airflow DAG or connector wrapper for the affected source and time range.
- Verify raw row counts and watermark movement.
- Re-run staging and intermediate model selections for the impacted window.

### Republish Ranked Queue
- Execute the warehouse transformation DAG through marts.
- Validate score distribution checks and owner queue counts.
- Release strategy generation only after tests pass.

### Disable CRM Dispatch
- Set `CRM_WRITEBACK_ENABLED=false`.
- Continue signal ingestion and queue publication to keep warehouse state current.

## Incident Response
- Source outage: stop the connector, preserve watermark state, and page the integration owner.
- Warehouse failure: stop downstream strategy generation and CRM dispatch until marts are current.
- Recommendation quality issue: disable automated dispatch and route output for human review.
