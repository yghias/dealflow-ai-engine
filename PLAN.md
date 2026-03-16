# Implementation Plan

The approved build plan uses AWS, Snowflake, S3, Airflow, Python, and OpenAI to support signal ingestion, entity enrichment, SQL-first warehouse modeling, AI strategy generation, and CRM lifecycle automation. Warehouse layers follow `raw -> staging -> transformations -> marts`, with Python reserved for ingestion, orchestration, AI calls, and external integrations.
