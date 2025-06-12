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

    