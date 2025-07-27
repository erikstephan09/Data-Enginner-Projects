
# X Data Pipeline

## Introduction

This is a simple project for beginner data engineers. We will extract information from X (formerly Twitter) accounts and analyze the average time between posts for each account.

---

## Project Architecture

### 1. X (Twitter) API Setup

### Create an X account
If you do not have an account, sign up here:  
🔗 https://x.com/i/flow/signup
### Get Developer Access
Log into the X Developer Platform and extract your `BEARER_TOKEN`: 
🔗 https://developer.x.com/en

📝 **Tip:** Watch this video to learn how to configure the developer platform:  
🔗 https://www.youtube.com/watch?v=aZz9D0FdevA

Save your `BEARER_TOKEN`, as you'll use it in the ETL code.

For more details:  
🔗 https://docs.x.com/resources/fundamentals/developer-portal

---

### 2. Docker Setup

> 💡 If you are experienced with Docker or using a custom setup, feel free to skip this section.

We will use Docker Desktop to create a containerized environment for Apache Airflow.

#### Download Docker
Install Docker Desktop from the official website:  
🔗 https://www.docker.com/

#### Project Structure
Make sure your project folder contains the following subfolders (create them manually or via terminal):
```bash 
mkdir dags logs config plugins
```
Also ensure these files exist in your project root.
- docker-compose.ymal
- requirements.txt

docker-compose.ymal volume setup (example)
	volumes:
    - ${AIRFLOW_PROJ_DIR:-.}/dags:/opt/airflow/dags
    - ${AIRFLOW_PROJ_DIR:-.}/logs:/opt/airflow/logs
    - ${AIRFLOW_PROJ_DIR:-.}/config:/opt/airflow/config
    - ${AIRFLOW_PROJ_DIR:-.}/plugins:/opt/airflow/plugins

---
### 3. Add DAG Files 
Inside the dags/ folder, place the following scripts:
- x_dag.py
- x_etl.py

---

### 4. Start Airflow with Docker
Run the following command in your terminal:

	docker compose up -d --build

Check that the services are up and running:

	docker ps

Wait until the Airflow webserver shows healthy status.

---

### 5. Create an Airflow User

Replace "container-name" with your webserver container name and run:

```bash
docker exec -it "container-name" airflow users create \
  --username your_user \
  --firstname Your \
  --lastname Name \
  --role Admin \
  --email your@email.com \
  --password your_password

```
If you are in windows, use the next code:

	docker exec -it "container-name" airflow users create --username user --firstname name --lastname last --role Admin --email email@email.com --password password

---

### 6. Access Airflow Web UI
Once Airflow is healthy, open your browser and go to:

🔗 http://localhost:8080

Log in using the credentials you created.

---

### 7. Run Your DAG

- Locate your DAG((e.g., x_dag) in the Airflow UI.
- Enable and trigger it to begin execution.

---

### Ready to Extract & Analyze!

All your csv files will save into plugins folder.
