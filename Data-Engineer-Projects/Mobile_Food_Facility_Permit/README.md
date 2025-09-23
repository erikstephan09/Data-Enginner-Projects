# Mobile Food Facility Permit Project


## Overview

This project demonstrates an end-to-end ETL (Extract, Transform, Load) data pipeline designed to collect, process, and analyze Mobile Food Facility Permit data. It focuses on managing and exploring information about food vendors operating under city permits.

The project combines data engineering, cloud infrastructure, and data visualization to support city health inspections, vendor compliance, and business insights.

## Project Architecture

![image_alt](https://github.com/erikstephan09/Data-Enginner-Projects/blob/3a555dedd9e4ae52e666c3299fd592efaa95d107/Pipelines-Projects/Mobile_Food_Facility_Permit/MFFP%20Diagram.png)

## Introduction

The dataset provides information about food vendors operating under city permits, including:

- Vendor names and business locations
- Facility types (e.g., trucks, push carts)
- Types of food sold
- Permit status and expiration dates

Using SQL queries and Power BI dashboards, this project allows you to:
- Monitor permit activity and compliance
- Identify popular food categories
- Track expiration trends to support inspections and vendor operations

### 🛠️ Project Objectives

1. Implement Infrastructure as Code (IaC) using Terraform to deploy the cloud environment.
2. Extract, clean, and transform raw permit data into a structured format.
3. Load the transformed CSV data into an Amazon S3 bucket as part of the ETL process.
4. Query the data using Amazon Athena or PostgreSQL to generate insights.
5. Build Power BI dashboards to visualize permit status, expiration timelines, and vendor trends.

### 🧰 Requirements

- Docker Desktop.
- Terraform.
- Python 3.9 or Higher.
- AWS Cloud Account.

### Web Page

<link> [https://data.sfgov.org/)

## Project Structure

```
 MobileFoodPermitProject/
   │
   ├── pipeline/                 # Airflow DAGs, requirements.txt, and Docker Compose files
   │   ├── dags/                 # Python DAGs for ETL
   │   ├── docker-compose.yml    # Airflow Docker configuration
   │   └── requirements.txt      # Python dependencies
   │
   ├── raw\_data/                 # Raw CSV data from the dataset
   │   └── mobile\_food\_permits.csv
   │
   ├── terraform/                # IaC configuration for AWS infrastructure
   │   ├── main.tf   			# Main Terraform file
   │   ├── provider.tf        # Cloud provider
   │   ├── variables.tf       # Variables for AWS resources
   │   └── outputs.tf         # Outputs from Terraform deployment
   │
   ├── dashboard/            # Power BI files and visualizations
   │   └── MobileFoodDashboard.pbix
   │
   └── README.md            # Project documentation
```







