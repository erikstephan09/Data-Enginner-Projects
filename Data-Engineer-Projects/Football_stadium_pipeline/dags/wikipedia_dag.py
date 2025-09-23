from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
from football_stadiom import wikipedia_pipeline_run

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 6, 9),
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=1),
}


with DAG(

    dag_id = "wikipedia_dag",
    default_args=default_args,
    description = "Wikipedia footboll stadium pipeline",
    schedule_interval = "@daily",
    catchup = False

) as dag:
    
    run = PythonOperator(
        task_id = "wikipedia_pipeline",
        python_callable = wikipedia_pipeline_run,
        op_kwargs = {'wikipedia_url' : 'https://en.wikipedia.org/wiki/List_of_association_football_stadiums_by_capacity'}
    )