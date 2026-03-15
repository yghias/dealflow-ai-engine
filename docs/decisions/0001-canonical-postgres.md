# ADR 0001: Canonical Postgres Operational Store

## Status
Accepted

## Context
The platform needs a strongly governed operational store for signals, entities, scoring artifacts, tasks, and audit metadata.

## Decision
Use Postgres as the canonical operational store and analytical seed layer.

## Consequences
- Faster initial implementation.
- Strong transactional guarantees for sync and writeback flows.
- Straightforward evolution toward marts, `pgvector`, and downstream BI.
