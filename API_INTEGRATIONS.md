# API Integrations

## Design Principles
- Keep provider-specific behavior inside adapters.
- Persist raw provider responses before warehouse transformation.
- Treat outbound CRM calls as operational side effects with explicit retry and replay handling.

## Source Interfaces
- News and press release APIs.
- Hiring feeds and company-change providers.
- Filing and transcript sources.
- CRM extracts for accounts, contacts, opportunities, activities, and tasks.

## Internal Endpoints
- `GET /health`
- `GET /signals/mock`
- `POST /workflow/process`

## Adapter Controls
- Timeouts and backoff for every external request.
- Source-level correlation ids in logs.
- Stable request and response schemas for warehouse loading.
- Idempotent CRM writeback using deterministic task keys.
