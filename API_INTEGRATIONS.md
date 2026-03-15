# API Integrations

## Integration Philosophy
- Hide provider-specific details behind adapters.
- Normalize external objects into canonical contracts before business logic consumes them.
- Keep read paths and write paths independently testable.

## External Interfaces

### Signal Providers
- News APIs.
- RSS / XML feeds.
- Job posting APIs.
- Filing and transcript providers.
- Web scrapers for company sites.

### CRM Providers
- Salesforce.
- HubSpot.
- Pipedrive.

### Collaboration Providers
- Slack.
- Email provider APIs.
- Optional ticketing systems.

## Internal Service Endpoints

### `POST /signals/ingest`
Trigger a signal ingestion run for a configured source.

### `GET /signals/ranked`
Return ranked opportunities with explanations and latest recommendation status.

### `POST /strategies/generate`
Generate a strategy for a specific signal or account.

### `POST /tasks/dispatch`
Dispatch approved tasks into CRM or collaboration channels.

### `GET /health`
Return readiness and dependency health.

## Adapter Requirements
- Retries for transient failures.
- Rate limit awareness.
- Explicit response mapping into Pydantic models.
- Structured logging with provider, endpoint, and correlation identifiers.
