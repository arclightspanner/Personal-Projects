"""OBTAIN INFORMATION OF THE DATA"""

# Import pandas into the environment
import pandas as pd

# Import marketing.csv 
marketing = pd.read_csv('marketing.csv')

# Print the first five rows of the DataFrame
print(marketing.head())

# Print the summary statistics of all columns
print(marketing.describe())

# Check column data types and non-missing values
print(marketing.info())