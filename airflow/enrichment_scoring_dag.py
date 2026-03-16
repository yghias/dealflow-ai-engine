from datetime import datetime

try:
    from airflow import DAG
    from airflow.operators.python import PythonOperator
except Exception:  # pragma: no cover
    DAG = None
    PythonOperator = None

from src.enrichment.company_enrichment import enrich_company_records
from src.scoring.company_scoring import score_companies


if DAG and PythonOperator:
    with DAG(
        dag_id="enrichment_scoring_dag",
        start_date=datetime(2026, 1, 1),
        schedule="@hourly",
        catchup=False,
    ) as dag:
        enrich_task = PythonOperator(task_id="enrich_companies", python_callable=enrich_company_records)
        score_task = PythonOperator(task_id="score_companies", python_callable=score_companies)
        enrich_task >> score_task
