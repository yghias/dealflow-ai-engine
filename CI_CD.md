# CI/CD

## Continuous Integration
- Python linting
- Python tests
- SQL validation
- dbt-style model checks
- contract validation

## Continuous Delivery
- build container image
- validate airflow DAG imports
- validate warehouse SQL assets
- deploy to development or staging environment

## Promotion Rule
No production deployment without:
- passing Python tests
- passing SQL tests
- passing DAG validation
