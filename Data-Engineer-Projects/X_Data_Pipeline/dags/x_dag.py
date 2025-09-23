from datetime import timedelta, datetime
from airflow import DAG
from airflow.operators.python import PythonOperator
from x_etl import run_x_etl

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 4, 28),
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
}

with DAG(
    dag_id="x_dag",
    default_args=default_args,
    description="My first etl code",
    schedule_interval="@daily",  # Puedes cambiar esto según lo que necesites
    catchup=False,
) as dag:

    run_etl = PythonOperator(
        task_id="complete_x_etl",
        python_callable=run_x_etl,
        op_kwargs={'lst_user': ['Cristiano', 'DavooXeneizeJRR', 'elonmusk', 'FabrizioRomano', 'lautarodelcampo']}
        )