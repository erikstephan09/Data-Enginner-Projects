# ⚽ Wikipedia Football Pipeline

# Project Architecture 

![image_alt](https://github.com/erikstephan09/Data-Enginner-Projects/blob/958384f9940ed17a276d331c4f19402dd222b75a/Pipelines-Projects/Football_stadium_pipeline/Data%20Pipeline%20Architecture.png)



## Introduction

This project demonstrates an end-to-end ETL (Extract, Transform, Load) data pipeline designed to collect and analyze information about football stadiums from a Wikipedia page.
The goal is to extract stadium data, store it in the cloud, and perform analytical queries using AWS services.
The pipeline uses a combination of open-source tools and cloud services:
- Tools: Apache Airflow, Docker, PostgreSQL

- AWS Services: S3, Glue, Athena, Redshift

### 🛠️ Project Objectives
- Extract football stadium data from Wikipedia.
- Store the structured data in an AWS S3 bucket.
- Query the data using AWS Athena or AWS Redshift.
- Perform data analysis to answer specific business questions.

### ❓Key Analytical Questions

- 🏟️ What are the top 5 stadiums by capacity?
- 🌍 What is the average stadium capacity by region?
- 🗺️ How many stadiums are there in each country?
- 🏆 What is the ranking of stadiums in each region based on capacity?
- 🥇 What are the top 3 stadiums in each region?
- 📈 Which stadiums have a capacity above the global average?

---
## 🧰 Requirements 

- Docker Desktop.
- PostgresSQL.
- Python 3.9 or higher.
-  AWS Cloud Account.

## 🌐 Wikipedia Page
 <link> https://en.wikipedia.org/wiki/List_of_association_football_stadiums_by_capacity

# Code
## ETL
    import requests
    from bs4 import BeautifulSoup
    import pandas as pd
    import re
    import boto3
    from credentials import AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, BUCKET_NAME, REGION_NAME, OBJECT_NAME
    import io
    from botocore.exceptions import ClientError
    
    def get_page(wikipedia_url):
        try:
            r= requests.get(wikipedia_url)
            r.raise_for_status() # Check if the requests was successful 
            print("Page downloading successfully.")
            http_text = r.text
            return http_text
        
        except requests.RequestException as e:
            print(f"Error downloading the page: {e}")
            return None
    
    
    def get_data(http_data):
    
        data_values = [] #Save the table
            
        soup = BeautifulSoup(http_data, 'html.parser')
        table = soup.find_all(name = 'table', class_= "wikitable")[1] #Select the second table from the page
        table_rows = table.find_all('tr') #Extract all <td> cells from each row
    
        for i in range(1, len(table_rows)): #Skip header row
            tds = table_rows[i].find_all('td')
    
    
            if len(tds) >=7: #Only process rows with at least 7 columns
                values = {
                    'rank': i,
                    'stadium': tds[0].text.strip().replace(" ♦", ""),
                    'capacity': int(re.sub(r'\[\d+\]', '', tds[1].text.strip()).replace(',', '')),
                    'region' : tds[2].text.strip(),
                    'country': tds[3].text.strip(),
                    'city': tds[4].text.strip(),
                    'home_teams': re.sub(r'\[\d+\]', '', tds[6].text.strip())
                }
                data_values.append(values)
            else:
                print(f"Row {i} skipped.")
        
        print(f"Total extracted rows: {len(data_values)}")
        return data_values
    
    def clean_data(dfs):
    
        for column in dfs.columns:
            dfs[column] = dfs[column].replace('', 'Unknown').fillna('Unknown')
    
        return dfs
    
    def get_dataframe(lst):
    
        dataframe = pd.DataFrame(lst)
        df = clean_data(dataframe)
    
        csv_buffer = io.StringIO()#Convert Dataframe to csv string
        df.to_csv(csv_buffer, index=False)
    
        try: 
            s3 = boto3.client('s3',
                              aws_access_key_id = AWS_ACCESS_KEY_ID,
                              aws_secret_access_key = AWS_SECRET_ACCESS_KEY,
                              region_name = REGION_NAME
                              ) #Upload to S3
            object_name = OBJECT_NAME
            bucket_name = BUCKET_NAME
    
            s3.put_object(Bucket = bucket_name, Key= object_name, Body = csv_buffer.getvalue())
            print("Uploading CSV file to S3 Bucket succesfully!") #Saving CSV file into my s3 bucket.
        
        except ClientError as e:
            print(f"An error occurred: {e}")
            return None
    
    
    def wikipedia_pipeline_run(wikipedia_url):
    
        http = get_page(wikipedia_url) #Extract http from url
        data = get_data(http) # Get the data that we needed
        get_dataframe(data) # Save our data into a CSV file ando save this into our S3 bucket
    
## Dag
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
## SQL analysis 
Create wikipedia football table

```sql
CREATE TABLE IF NOT EXISTS wiki_football_db (
			rank INTEGER,
			stadium VARCHAR(100),
			capacity INTEGER,
			region VARCHAR(50),
			country VARCHAR(50),
			city VARCHAR(100),
			home_teams VARCHAR(1000)
)
```

 What are the top 5 stadiums by capacity?
```sql
SELECT 
	rank, stadium, region, country, city 
	FROM wiki_football_db
	ORDER BY rank
	LIMIT 5;
```
What is the average stadium capacity by region?
```sql
 SELECT 
 		AVG(capacity) AS avg_capacity,
		region
		FROM wiki_football_db
		GROUP BY region
		ORDER BY avg_capacity DESC
```
 How many stadiums are there in each country?
 ```sql
SELECT country, COUNT(country) as num_stadiums
		FROM wiki_football_db
		GROUP BY country
		ORDER BY num_stadiums DESC;
```
What is the ranking of stadiums in each region based on capacity?
```sql
SELECT rank, stadium, region,
		RANK() OVER(PARTITION BY region ORDER BY capacity DESC) as region_rank
		FROM wiki_football_db;
```
 What are the top 3 stadiums in each region?
 ```sql
with stadiums_ranking AS (
	SELECT rank,
			stadium,
			region,
			RANK() OVER(PARTITION BY region ORDER BY capacity DESC) as ranking
	FROM wiki_football_db
)
	SELECT * from stadiums_ranking
	WHERE ranking <= 3;
```
Which stadiums have a capacity above the global average?
```sql
WITH avg_capacity AS (
	SELECT stadium, region,
	capacity, 
	AVG(capacity) OVER (PARTITION BY region) AS avg_capacity
	FROM wiki_football_db
)
	SELECT * FROM avg_capacity
	WHERE capacity >= avg_capacity
	ORDER BY region;
```
