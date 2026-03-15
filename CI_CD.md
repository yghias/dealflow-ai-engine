# CI/CD

## CI Stages
1. Lint and format validation.
2. Static typing and import checks.
3. Unit tests.
4. Integration tests with Postgres.
5. SQL validation and migration checks.
6. Prompt and sample payload schema validation.

## CD Stages
1. Build versioned Docker images.
2. Deploy to development.
3. Run smoke tests.
4. Promote to staging.
5. Manual approval for production.

## Release Principles
- Treat SQL, prompts, and code as deployable artifacts.
- Maintain backwards-compatible API and schema changes where possible.
- Gate prompt/model changes behind explicit configuration.
