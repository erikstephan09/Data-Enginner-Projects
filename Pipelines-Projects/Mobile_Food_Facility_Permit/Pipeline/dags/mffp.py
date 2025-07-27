import requests
import pandas as pd
import boto3 as b3
from botocore.exceptions import ClientError
import io


#extract_csv_file(url)
def extract_csv_file(url_page):

    csv_name = 'Mobile_Food_Facility_permit.csv'
    
    try:
        r = requests.get(url_page)
        status = r.status_code

        if status == 200:

            with open(csv_name, 'wb') as f:
                f.write(r.content)
                print("File download successfully")

            return csv_name
        else:
            print(f"Failed to download file. Status code: {r.status_code}")
        
    except requests.exceptions as e:
        print(f"An error occurred:{e}")


# Data cleaning 
def clean_data(csv_path):
    data = pd.read_csv(csv_path)
    df = pd.DataFrame(data)
    # Dropping unnecessary columns
    df.drop(columns=['dayshours', \
                    'noisent', \
                    'location', \
                    ':@computed_region_yftq_j783', \
                    ':@computed_region_p5aj_wyqh', \
                    ':@computed_region_rxqg_mtj9', \
                    ':@computed_region_bh8s_q3mv', \
                    ':@computed_region_fyvs_ahh9'], inplace = True)


    #Cleaning all the columns
    df['applicant'] = df['applicant'].apply(lambda x: 'Unknown' if  pd.isna(x) else x)
    df['facilitytype'] = df['facilitytype'].apply(lambda x: 'Unknown' if  pd.isna(x) else x)
    df = df[df['cnn'] != 0] #Droping rows that contain the value 0 
    df['locationdescription'] = df['locationdescription'].apply(lambda x: 'Unknown' if pd.isna(x) else x)
    df['address'] = df['address'].apply(lambda x: 'Unknown' if pd.isna(x) else x)
    df['blocklot'] = df['blocklot'].apply(lambda x: 'Unknown' if pd.isna(x) else x)
    df['block'] = df['block'].apply(lambda x: 'Unknown' if pd.isna(x) else x)
    df['lot'] = df['lot'].apply(lambda x: 'Unknown' if pd.isna(x) else x)
    df['permit'] = df['permit'].apply(lambda x: 'Unknown' if pd.isna(x) else x)
    df['status'] = df['status'].apply(lambda x: 'Unknown' if pd.isna(x) else x)
    df['fooditems'] = df['fooditems'].apply(lambda x: 'Unknown' if pd.isna(x) else x)
    df['x'] = df['x'].apply(lambda x: 0 if pd.isna(x) else x)
    df['y'] = df['y'].apply(lambda x: 0 if pd.isna(x) else x)
    df['latitude'] = df['latitude'].apply(lambda x: 0 if pd.isna(x) else x)
    df['longitude'] = df['longitude'].apply(lambda x: 0 if pd.isna(x) else x)
    df['schedule'] = df['schedule'].apply(lambda x: 'Unknown' if pd.isna(x) else x)
    df['approved'] = pd.to_datetime(df['approved'], errors='coerce')
    df['approved'] = df['approved'].fillna(pd.Timestamp('2025-01-01'))
    df['approved'] = df['approved'].dt.strftime('%Y-%m-%d')
    df['approved'] = df['approved'].str.strip()
    df['received'] = pd.to_datetime(df['received'])
    df['received'] = df['received'].fillna(pd.Timestamp('2025-01-01'))
    df['received'] = df['received'].dt.strftime('%Y-%m-%d')
    df['expirationdate'] = pd.to_datetime(df['expirationdate'], errors='coerce')
    df['expirationdate'] = df['expirationdate'].fillna(pd.Timestamp('2025-01-01'))
    df['expirationdate'] = df['expirationdate'].dt.strftime('%Y-%m-%d')
    df['expirationdate'] = df['expirationdate'].str.strip()

    #Add index column
    df['id'] = df.index
    #Convert cleaned DF to CSV string in-memory
    buffer = io.StringIO()
    df.to_csv(buffer, index=False)
    buffer.seek(0) #Move pointer to the beginning
    return buffer.getvalue()

# Data Load 
def load_csv_file(dataframe, aws_key, aws_secret_key, aws_bucket_name, aws_region, aws_object_name):

    buffer = io.StringIO(dataframe)
    df = pd.read_csv(buffer)

    csv_buffer = io.StringIO()#Convert Dataframe to csv string without creating an actual csv file
    df.to_csv(csv_buffer, index= False) 

    try: 
        s3 = b3.client(
            's3',
            aws_access_key_id = aws_key,
            aws_secret_access_key = aws_secret_key,
            region_name = aws_region
        ) #Upload to S3

        bucket_name = aws_bucket_name
        object_name = aws_object_name
        

        s3.put_object(Bucket = f"{bucket_name}/data", Key = object_name, Body = csv_buffer.getvalue())
        print("Uploading CSV file to S3 Bucket succesfully!") #Saving CSV file into my s3 bucket.

    except ClientError as e:
        print(f"An error occurred:{e}")
        return None
