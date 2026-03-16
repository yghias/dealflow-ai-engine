# ADR 0002: Snowflake and SQL-First Transformation Ownership

## Status
Accepted

## Context
The platform requires transparent ranking logic, repeatable analytics, and broad accessibility for analytics engineering and operations teams.

## Decision
Snowflake is the curated data platform, and SQL models own transformation, scoring inputs, marts, and warehouse data quality rules. Python remains limited to source ingestion, orchestration, external adapters, and utility execution.

## Consequences
- Ranking logic is easier to audit and operationalize.
- Data products become easier to expose to BI and downstream consumers.
- Python services remain simpler and lower risk.
