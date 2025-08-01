\# Mobile Food Facility Permit Project



\## Overview

This project demonstrates an end-to-end ETL (Extract, Transform, Load) data pipeline designed to collect, process, and analyze Mobile Food Facility Permit data. It focuses on managing and exploring information about food vendors operating under city permits.

The project combines data engineering, cloud infrastructure, and data visualization to support city health inspections, vendor compliance, and business insights.

\## Project Architecture



\## Introduction

The dataset provides information about food vendors operating under city permits, including:

\- Vendor names and business locations

\- Facility types (e.g., trucks, push carts)

\- Types of food sold

\- Permit status and expiration dates



Using SQL queries and Power BI dashboards, this project allows you to:

\- Monitor permit activity and compliance

\- Identify popular food categories

\- Track expiration trends to support inspections and vendor operations



\### 🛠️ Project Objectives

1\. Implement Infrastructure as Code (IaC) using Terraform to deploy the cloud environment.



2\. Extract, clean, and transform raw permit data into a structured format.



3\. Load the transformed CSV data into an Amazon S3 bucket as part of the ETL process.



4\. Query the data using Amazon Athena or PostgreSQL to generate insights.



5\. Build Power BI dashboards to visualize permit status, expiration timelines, and vendor trends.



\### 🧰 Requirements

\- Docker Desktop.

\- Terraform.

\- Python 3.9 or Higher.

\- AWS Cloud Account.



\### Web Page

<link> https://data.sfgov.org/Economy-and-Community/Mobile-Food-Facility-Permit/rqzj-sfat/about\_data



\## Project Structure



&nbsp;   MobileFoodPermitProject/

&nbsp;   │

&nbsp;   ├── pipeline/                 # Airflow DAGs, requirements.txt, and Docker Compose files

&nbsp;   │   ├── dags/                 # Python DAGs for ETL

&nbsp;   │   ├── docker-compose.yml    # Airflow Docker configuration

&nbsp;   │   └── requirements.txt      # Python dependencies

&nbsp;   │

&nbsp;   ├── raw\_data/                 # Raw CSV data from the dataset

&nbsp;   │   └── mobile\_food\_permits.csv

&nbsp;   │

&nbsp;   ├── terraform/                # IaC configuration for AWS infrastructure

&nbsp;   │   ├── main.tf   			# Main Terraform file

&nbsp;   │   ├── provider.tf        # Cloud provider

&nbsp;   │   ├── variables.tf       # Variables for AWS resources

&nbsp;   │   └── outputs.tf         # Outputs from Terraform deployment

&nbsp;   │

&nbsp;   ├── dashboard/            # Power BI files and visualizations

&nbsp;   │   └── MobileFoodDashboard.pbix

&nbsp;   │

&nbsp;   └── README.md            # Project documentation







