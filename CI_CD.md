# CI/CD

## Continuous Integration
1. Validate Python formatting and imports.
2. Run unit and integration tests.
3. Parse and validate SQL model dependencies.
4. Execute SQL assertions and reconciliation queries.
5. Build API and Airflow runtime container images.

## Continuous Delivery
1. Publish versioned images.
2. Deploy to development environment.
3. Run smoke tests against control-plane endpoints and Snowflake connectivity.
4. Promote to staging after warehouse data contract validation.
5. Require manual approval before production release.

## Release Controls
- Schema changes require matching SQL tests and documentation updates.
- New marts require named owners and consumer documentation.
- Prompt changes require benchmark review before production rollout.
