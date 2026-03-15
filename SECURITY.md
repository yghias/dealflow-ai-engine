# Security

## Core Controls
- Secrets stored outside the repository.
- Least-privilege API tokens for source and CRM integrations.
- TLS for external service traffic.
- Encryption at rest for primary stores.
- PII-aware logging and redaction.
- Approval boundaries for autonomous CRM writes if business risk is high.

## Secure Development Practices
- Dependency scanning in CI.
- Secret scanning in pre-commit and CI.
- Separate service accounts by environment.
- Audit logs for privileged actions and CRM writebacks.
