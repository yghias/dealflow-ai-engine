# Testing

## Test Layers
- Unit tests for parsers, scoring logic, prompt builders, and adapters.
- Integration tests for Postgres persistence, API endpoints, and CRM mapping.
- Contract tests for source and CRM payload schemas.
- End-to-end tests covering ingest-to-task flow on sample fixtures.

## Test Data Principles
- Keep fixtures sanitized and deterministic.
- Include edge cases for duplicate signals, ambiguous entities, and failed CRM writes.
- Snapshot AI outputs only for schema shape and routing behavior, not exact phrasing.
