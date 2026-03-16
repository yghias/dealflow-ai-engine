# Testing

## Coverage Model
- Unit tests cover connector parsing, validation, and workflow control paths.
- Integration tests cover API endpoints and CRM adapter behavior.
- SQL tests cover key uniqueness, accepted values, score range constraints, and reconciliation.
- End-to-end tests cover signal landing through task dispatch using fixtures.

## Minimum Expectations
- Staging models validate required keys and enumerations.
- Intermediate models validate join completeness and score component ranges.
- Marts validate freshness, owner routing coverage, and downstream task parity.
