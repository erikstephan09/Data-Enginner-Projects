from airflow import DAG 
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import mffp
from credentials import AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME, REGION_NAME, OBJECT_NAME


default_args = {
    'owner' : 'airflow',
    'depends_on_past' : False,
    'start_date' : datetime(2025,6,23),
    'retries' : 1,
    'retry_delay': timedelta(minutes=1)
}

with DAG (
    dag_id = "mffp_pipeline",
    default_args = default_args,
    description = "Mobile Food Facility Permit Pipeline",
    schedule_interval = "@daily",
    tags = ["page", "elt", "pipeline"],
    catchup = False

) as dag:
    
    extract = PythonOperator(
        task_id = "mffp_extract_information",
        python_callable = mffp.extract_csv_file,
        op_kwargs = {'url_page' : 'https://data.sfgov.org/resource/rqzj-sfat.csv'}
    )
    
    transform = PythonOperator(
        task_id = "mffp_transform_data",
        python_callable = mffp.clean_data,
        op_kwargs = {'csv_path' : "{{ti.xcom_pull(task_ids = 'mffp_extract_information')}}"}
    )

    load = PythonOperator(
        task_id = "mffp_load_s3_bucket",
        python_callable = mffp.load_csv_file,
        op_kwargs = {
            'dataframe' : "{{ti.xcom_pull(task_ids = 'mffp_transform_data')}}",
            'aws_key' : AWS_ACCESS_KEY_ID,
            'aws_secret_key' : AWS_SECRET_ACCESS_KEY,
            'aws_bucket_name' : BUCKET_NAME,
            'aws_region' : REGION_NAME,
            'aws_object_name' : OBJECT_NAME
        }
    )

    extract >> transform >> load