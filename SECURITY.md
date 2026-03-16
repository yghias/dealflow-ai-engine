# Security

## Core Controls
- Secrets are injected through environment or secret management systems, never committed.
- Separate service accounts are used for raw loading, transformation execution, and CRM writeback.
- CRM writeback credentials are isolated from read-only extraction credentials.
- Sample data excludes sensitive CRM fields and direct contact information.

## Runtime Controls
- Snowflake roles are segmented by raw landing, transform execution, and read-only analytics.
- Airflow connections and API credentials are environment-scoped.
- Container images are scanned before promotion.
