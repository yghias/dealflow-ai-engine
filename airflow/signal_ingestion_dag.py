from datetime import datetime

try:
    from airflow import DAG
    from airflow.operators.python import PythonOperator
except Exception:  # pragma: no cover
    DAG = None
    PythonOperator = None

from src.ingestion.api_ingest import fetch_company_signals


def run_signal_ingestion() -> list[dict]:
    return fetch_company_signals()


if DAG and PythonOperator:
    with DAG(
        dag_id="signal_ingestion_dag",
        start_date=datetime(2026, 1, 1),
        schedule="*/30 * * * *",
        catchup=False,
    ) as dag:
        PythonOperator(task_id="fetch_company_signals", python_callable=run_signal_ingestion)
