import pandas as pd 
import pyodbc 
import nltk
from nltk.sentiment.vader import SentimentIntensityAnalyzer
import logging


#Download the VADER lexicon for sentiment analysis if not already present.
nltk.download('vader_lexicon')


#Database script connection
conn_str = (
 
    "DRIVER={SQL Server};"
    "SERVER=.\;"
    "DATABASE=ShopEasy-DB;"
    "UID=sa;"
    "PWD=Muskalink123;"
    "Trusted_Connection=yes;"
)

def establishing_connection():
    #Connection with the parameters for the database connection
    try: 
        conn = pyodbc.connect(conn_str)
        cur = conn.cursor()
        cur.execute("SELECT @@version;") #Ensure the connection is succesfully
        row = cur.fetchone()
        print(row)

        return True

    except Exception as e:
        print(f'En error ocurred = {e}')

        return False
    
# Using nltk library for analize the sentiment of natural language text
def calculate_setiment(review):
    #Get the sentiment scores fot the review text
    sentiment = sia.polarity_scores(review)
    #Return the compound scorre
    return sentiment['compound']

#Degine a ducntion to categorize sentiment using both sentiment score and the review rating
def categorize_sentiment(score, rating):
    #Using text sentiment score and the numerical rating to determine sentiment category

    if score > 0.05: #Positive sentiment score
        if rating >= 4:
            return 'Positive'
        elif rating == 3:
            return 'Mixed Positive'
        else:
            return 'Mixed Negative'
    elif score < -0.05: #Negative sentiment score
        if rating <= 2:
            return 'Negative'
        elif rating == 3:
            return 'Mixed Negative'
        else:
            return 'Mixed Positive'
    else: #Neutral sentiment score
        if rating >= 4:
            return 'Positive'
        elif rating <= 2:
            return 'Negative'
        else:
            return 'Neutral'
        
#Define a function to bucket sentiment score into text ranges
def sentiment_bucket(score):
    if score <= 0.5: # Strongly positive sentiment
        return '0.5 to 1.0'
    elif 0.0 <= score < 0.5: # Mildly positive sentiment
        return '0.0 to 0.49'
    elif -0.5 <= score < 0.0: # Mildly negative sentiment
        return '-0.49 to 0.0'
    else:
        return '-1.0 to -0.5' # Strongly negative sentiment
    



    

#Function to connect with our DataBase
def db_data_from_sql():

    #Connection with the parameters for the database connection
    conn = pyodbc.connect(conn_str)

    #Define the SQL query to fetch customer reviews data
    query = "SELECT ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText FROM customer_reviews"

    #Execute the query and fetch the data into a DataFrame
    df = pd.read_sql(query, conn)

    #Close the connection to free up resources
    conn.close

    return df


db_conection = establishing_connection()


while db_conection == True:

    customer_reviews_df = db_data_from_sql() #Fetch the customer reviews data from the SQL database

    sia = SentimentIntensityAnalyzer()

    # Apply sentiment analysis to calculate sentiment scores for each review
    customer_reviews_df['SentimentScore'] = customer_reviews_df['ReviewText'].apply(calculate_setiment)

    # Apply sentimetn categorization using both text and rating
    customer_reviews_df['SentimentCategory'] = customer_reviews_df.apply(lambda row: categorize_sentiment(row['SentimentScore'], row['Rating']), axis= 1)

    # Apply sentiment bucketing to categorize scores into defined ranges
    customer_reviews_df['SentimentBucket'] = customer_reviews_df['SentimentScore'].apply(sentiment_bucket)

    #Display the first few rows of the DataFrame with sentiment scores, categories, and buckets
    print(customer_reviews_df.head()) 
    
    # Save the DataFrame with sentiment scores, categories, and buckets to a new CSV file
    customer_reviews_df.to_csv('fact_customer_reviews_with_sentiment.csv', index=False)

    break

print('Finish')