import pandas as pd
import tweepy
from datetime import datetime
import time

def run_x_etl(lst_user):
    bearer_token =  "bearer_token"

    client = tweepy.Client(bearer_token=bearer_token)
    try:
        tweet_lst = []
        for x_user in lst_user:

            user = client.get_user(username=x_user)
            user_id = user.data.id
    
            tweets = client.get_users_tweets(
                id=user_id,
                exclude="retweets,replies",
                max_results=10, #Extract 10 tweets 
                tweet_fields=["created_at", "lang", "source", "public_metrics"]
            )
            
            if tweets.data:
                for tweet in tweets.data:
                    print(tweet.text)

                    refined_tweet = {
                        "user": user_id,
                        "text": tweet.text,
                        "time": tweet.created_at,
                        "language": tweet.lang,
                        "source": tweet.source,
                        "retweet_count": tweet.public_metrics['retweet_count'],
                        "reply_count": tweet.public_metrics['reply_count'],
                        "like_count": tweet.public_metrics['like_count'],
                        "quote_count": tweet.public_metrics['quote_count']
                    }
                    
                    tweet_lst.append(refined_tweet)
                #Save the information into dataframa
                df = pd.DataFrame(tweet_lst)
                csv_path = f"/opt/airflow/plugins/{x_user}.csv"

                df.to_csv(csv_path, index=False)

            else:
                print("No tweets found.")
            
            print("Waiting 15 min to meet rate limit of X...")
            time.sleep(15 * 60)
            
    except tweepy.TooManyRequests:
        print("Rate limit exceeded. Wait 15 minutes...")
        time.sleep(15 * 60)

    except Exception as e:
        print(f"An error occurred: {e}")


