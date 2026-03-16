# AI Workflows

## AI Enrichment Workflows
- Summarize noisy external signals into concise evidence objects
- Infer investor relevance from funding and relationship history
- Generate deal theses and outreach plans from structured warehouse inputs
- Produce explainable prioritization narratives tied to score components

## Strategy Workflow
1. Read ranked deal and investor targeting records from Snowflake marts.
2. Build structured context from company, investor, contact, and signal datasets.
3. Call OpenAI with a JSON-constrained prompt.
4. Validate strategy payload shape.
5. Persist output and trigger CRM automation if approval rules pass.

## Guardrails
- Use structured warehouse inputs only
- Require evidence fields in every recommendation
- Include model version and prompt version
- Route low-confidence recommendations to manual review
