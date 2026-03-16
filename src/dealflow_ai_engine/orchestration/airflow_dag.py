from __future__ import annotations

from datetime import datetime

try:
    from airflow import DAG
    from airflow.operators.python import PythonOperator
except Exception:  # pragma: no cover
    DAG = None
    PythonOperator = None

from dealflow_ai_engine.ingestion.connectors.mock_signals import fetch_mock_signals


def load_mock_signals() -> list[dict[str, object]]:
    return [signal.model_dump() for signal in fetch_mock_signals()]


if DAG and PythonOperator:
    with DAG(
        dag_id="dealflow_signal_intelligence",
        start_date=datetime(2026, 1, 1),
        schedule="*/30 * * * *",
        catchup=False,
        tags=["dealflow", "signals"],
    ) as dag:
        PythonOperator(task_id="extract_mock_signals", python_callable=load_mock_signals)
