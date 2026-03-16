# Runbook

## Incident Response

### Ingestion Failure
- identify failing connector
- inspect last successful watermark
- replay source window after fix

### Enrichment Failure
- disable downstream scoring publish
- rerun enrichment batch
- validate late-arriving updates

### Scoring Anomaly
- compare current score distribution to trailing baseline
- isolate changed source or enrichment inputs
- pause CRM automation if threshold breach is material
