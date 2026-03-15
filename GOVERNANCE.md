# Governance

## Goals
- Maintain trust in external data and AI-assisted recommendations.
- Preserve reproducibility for decision-making and audit.
- Minimize risk around PII, sensitive CRM notes, and model-generated output.

## Governance Controls
- Source provenance on externally derived attributes.
- Prompt and model version tracking.
- Field-level PII tagging in canonical schemas.
- Role-based access for CRM writeback and sensitive record views.
- Retention policies for raw documents, prompts, outputs, and logs.
- Review workflows for low-confidence entity matches and AI recommendations.

## Lineage Expectations
- Dashboards must trace back to marts, core tables, staging data, and raw payloads.
- Scoring and strategy recommendations must be reproducible from stored snapshots.
- Manual overrides should be captured as first-class events, not hidden edits.

## Data Stewardship
- Platform engineering owns schema evolution and pipeline reliability.
- Operations teams own CRM field mappings and business routing rules.
- AI owners own prompt templates, benchmark sets, and release criteria.
