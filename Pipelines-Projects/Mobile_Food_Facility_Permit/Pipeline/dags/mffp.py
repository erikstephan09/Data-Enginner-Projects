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
    #Read csv file
    data = pd.read_csv(csv_path)

    #Create a DataFrame
    df = pd.DataFrame(data)

    # Dropping unnecessary columns
    df.drop(columns = ['dayshours'\
                   ,'noisent'\
                   , 'location'\
                   , 'x'\
                   , 'y'\
                   ,':@computed_region_yftq_j783'\
                   , ':@computed_region_p5aj_wyqh'\
                   ,':@computed_region_rxqg_mtj9'\
                   , ':@computed_region_bh8s_q3mv'\
                   , ':@computed_region_fyvs_ahh9'], inplace = True)
    
    # Adding index column
    df['index'] = df.index

    #Create a dictionary 
    new_columns_name = {
        'objectid' : 'object_id',
        'facilitytype' : 'facility_type',
        'locationdescription' : 'location_description',
        'blocklot' : 'block_lot',
        'fooditems' : 'food_items',
        'priorpermit' : 'prior_permit',
        'expirationdate' : 'expiration_date'}
    
    df.rename(columns = new_columns_name, inplace = True)

    #Filling Missing data
    df.fillna({
        'facility_type': 'Truck',
        'location_description': 'Not Provided',
        'block_lot': 'Unknown',
        'block': 'Unknown',
        'lot': 'Unknown',
        'food_items': 'Not Provided'}, inplace=True)
    
    df['approved'] = pd.to_datetime(df['approved'], errors = 'coerce')
    df['received'] = pd.to_datetime(df['received'].astype(str), format='%Y%m%d', errors='coerce')
    df['expiration_date'] = pd.to_datetime(df['expiration_date'], errors = 'coerce')
    
    df['index'] = df['index'].reset_index(drop= True)

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
        

        s3.put_object(Bucket = bucket_name, Key = f"data/{object_name}", Body = csv_buffer.getvalue())
        print("Uploading CSV file to S3 Bucket succesfully!") #Saving CSV file into my s3 bucket.

    except ClientError as e:
        print(f"An error occurred:{e}")
        return None
