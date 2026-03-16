# Data Model

## Canonical Schemas
The platform models the following core entities:
- companies
- investors
- contacts
- deals
- deal_signals
- company_signals
- investor_profiles
- outreach_events
- crm_activities
- deal_outcomes
- scoring_results

## Layering
- `raw`: landed payloads and source-native schemas
- `staging`: standardized typed records
- `transformations`: entity resolution, enrichment merge, relationship modeling, scoring features
- `marts`: business-facing analytics datasets

## Key Relationships
- `deals.company_id -> companies.company_id`
- `deal_signals.deal_id -> deals.deal_id`
- `company_signals.company_id -> companies.company_id`
- `crm_activities.company_id -> companies.company_id`
- `outreach_events.deal_id -> deals.deal_id`
- `deal_outcomes.deal_id -> deals.deal_id`
- `scoring_results.deal_id -> deals.deal_id`

## Modeling Notes
- Surrogate keys are used for canonical warehouse entities.
- Source ids are retained for lineage and deduplication.
- Event tables are append-only.
- Enrichment and scoring outputs are versioned snapshots.
