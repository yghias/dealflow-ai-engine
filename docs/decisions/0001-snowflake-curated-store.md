# ADR 0001: Snowflake as the Curated Platform Store

## Status
Accepted

## Context
The platform needs a warehouse capable of handling semi-structured raw payloads, curated analytical marts, and replayable score inputs without pushing transformation logic into the application layer.

## Decision
Use Snowflake as the curated platform store for raw landing, staged transformations, intermediate score models, and marts consumed by recommendation and reporting workflows.

## Consequences
- Ranking and KPI logic can live in SQL where analysts and analytics engineers can inspect it directly.
- Raw landing, staging, and marts stay within a single managed warehouse boundary.
- Operational writeback concerns remain in Python services rather than becoming the warehouse’s responsibility.
