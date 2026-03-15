# Runbook

## Local Development
1. Start Postgres with `docker compose up -d postgres`.
2. Install dependencies with `pip install -e .[dev]`.
3. Export environment variables from `.env`.
4. Run API: `uvicorn dealflow_ai_engine.api.app:app --reload`.
5. Execute tests: `pytest`.

## Common Operations

### Backfill Signals
- Run the relevant ingestion job with a source name and time window.
- Validate record counts in staging before promoting downstream.

### Recompute Scores
- Trigger the scoring service for a target cohort or run window.
- Compare output distributions with the prior baseline.

### Pause CRM Writeback
- Set `CRM_WRITEBACK_ENABLED=false`.
- Confirm tasks continue to persist internally for replay.

## Incident Response
- Triage source outages by connector and freshness lag.
- Route schema drift issues to ingestion maintainers.
- Disable autonomous strategy dispatch if schema validation or hallucination metrics degrade.
