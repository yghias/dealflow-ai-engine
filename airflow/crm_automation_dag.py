from datetime import datetime

try:
    from airflow import DAG
    from airflow.operators.python import PythonOperator
except Exception:  # pragma: no cover
    DAG = None
    PythonOperator = None

from src.orchestration.crm_automation import dispatch_crm_workflows


if DAG and PythonOperator:
    with DAG(
        dag_id="crm_automation_dag",
        start_date=datetime(2026, 1, 1),
        schedule="@hourly",
        catchup=False,
    ) as dag:
        PythonOperator(task_id="dispatch_crm_workflows", python_callable=dispatch_crm_workflows)
