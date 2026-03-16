# Governance

## Objectives
- Preserve traceability from raw signals to ranked queues, recommendations, and CRM actions.
- Keep warehouse transformations reproducible across reruns and late-arriving source data.
- Apply explicit controls to CRM-derived data, external provider data, and AI-generated output.

## Required Controls
- Source provenance on each landed and curated attribute.
- Prompt version, model name, and request identifier on every recommendation artifact.
- Manual override capture for entity resolution and queue suppression.
- PII classification for CRM and contact-derived columns.
- Retention policies for raw payloads, curated marts, prompts, and recommendation outputs.

## Ownership
- Platform engineering owns warehouse schemas, Airflow DAGs, SQL models, and data contracts.
- Deal operations owns routing policies, queue suppression logic, and CRM mapping rules.
- AI platform owners own prompt catalog, evaluation policy, and release controls.
