# Governance

## Canonical Entity Definitions
- Company: normalized operating entity or issuer
- Investor: institutional or individual capital provider
- Contact: person associated with a company or investor
- Deal: opportunity tracked through sourcing, qualification, and outcome
- Signal: external or internal event affecting prioritization

## Ownership
- Platform engineering owns ingestion, orchestration, infrastructure, and control-plane code
- Analytics engineering owns warehouse models, marts, and SQL tests
- Revenue or deal operations own CRM mappings and automation policies
- AI owners own prompts, evaluation rules, and release controls

## Standards
- snake_case identifiers
- source lineage columns on all curated tables
- timestamp columns in UTC
- no destructive overwrite of raw data
