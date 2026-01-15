# Import the pandas library for data manipulation
import pandas as pd
# Import TextBlob for sentiment analysis tasks
from textblob import TextBlob
# Import duckdb to interact with the DuckDB database
import duckdb
# Import the os module to handle file paths and checks
import os

# Define the absolute path to the source CSV file
csv_path = r'c:\Users\utente\PowerBI\Projet_cv\archive\philosophy_data.csv'
# Define the absolute path where the DuckDB database file will be created
db_path = r'c:\Users\utente\PowerBI\Projet_cv\philosophy.duckdb'

# Define a function to calculate the sentiment polarity of a given text
def calculate_sentiment(text):
    # Try block to handle potential errors during processing
    try:
        # Convert text to string and calculate polarity using TextBlob (-1 to 1)
        return TextBlob(str(text)).sentiment.polarity
    # Exception block to handle cases where text might be malformed
    except:
        # Return a neutral score of 0.0 in case of error
        return 0.0

# Define a function to calculate the number of words in a given text
def calculate_word_count(text):
    # Try block to handle potential errors
    try:
        # Convert text to string, split by whitespace, and count the resulting list items
        return len(str(text).split())
    # Exception block to handle errors
    except:
        # Return 0 word count in case of error
        return 0

# Main function to orchestrate the data loading and enrichment process
def load_data():
    # Print a message indicating the start of the data loading process
    print("Loading data...")
    # Check if the CSV file exists at the specified path
    if not os.path.exists(csv_path):
        # Print an error message if the file is missing
        print(f"Error: CSV file not found at {csv_path}")
        # Exit the function if file is not found
        return

    # Read the CSV file into a pandas DataFrame
    # low_memory=False is used to prevent warnings about mixed types in columns
    df = pd.read_csv(csv_path, low_memory=False)
    
    # Print the number of rows loaded from the CSV
    print(f"Loaded {len(df)} rows.")
    
    # Print a message indicating the start of the enrichment phase
    print("Enriching data (Sentiment & Word Count)...")
    # Apply the calculate_sentiment function to the 'sentence_str' column
    # Store the result in a new column 'sentiment_score'
    df['sentiment_score'] = df['sentence_str'].apply(calculate_sentiment)
    # Apply the calculate_word_count function to the 'sentence_str' column
    # Store the result in a new column 'sentence_word_count'
    df['sentence_word_count'] = df['sentence_str'].apply(calculate_word_count)
    
    # Print a message indicating the start of the database saving process
    print("Saving to DuckDB...")
    # Connect to the DuckDB database at the specified path (creates it if it doesn't exist)
    con = duckdb.connect(db_path)
    # Execute a SQL command to create or replace the 'raw_philosophy' table with data from the DataFrame 'df'
    con.execute("CREATE OR REPLACE TABLE raw_philosophy AS SELECT * FROM df")
    # Close the connection to the database
    con.close()
    
    # Print a success message confirming the data has been saved
    print(f"Done! Data saved to {db_path}")

# Check if the script is being run directly (not imported as a module)
if __name__ == "__main__":
    # Call the load_data function
    load_data()
