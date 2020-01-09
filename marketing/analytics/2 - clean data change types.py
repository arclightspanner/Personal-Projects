"""CHANGE DATA TYPE"""
# import data and get column information
import pandas as pd
marketing = pd.read_csv('marketing.csv')
print(marketing.descirbe())

# Check the data type of is_retained
print(marketing['is_retained'].dtype)

# Convert is_retained to a boolean
marketing['is_retained'] = marketing['is_retained'].astype('bool')

# Check the data type of is_retained, again
print(marketing['is_retained'].dtype)


"""FEATURE ENGINEERING ADDING NEW COLUMNS (MAPPING, BOOLEAN)"""
# Mapping for channels
channel_dict = {"House Ads": 1, "Instagram": 2, 
                "Facebook": 3, "Email": 4, "Push": 5}

# Map the channel to a channel code
marketing['channel_code'] = marketing['subscribing_channel'].map(channel_dict)

# Import numpy
import numpy as np

# Add the new column is_correct_lang
marketing['is_correct_lang'] = np.where(marketing['language_displayed'] == marketing['language_preferred'],'Yes', 'No')

# Import marketing.csv with date columns
marketing = pd.read_csv('marketing.csv', parse_dates = ['date_served','date_subsribed','date_canceled'])

# Import marketing.csv with date columns
marketing = pd.read_csv('marketing.csv', parse_dates = ['date_served','date_subscribed','date_canceled'])

# Add a DoW column
marketing['DoW'] = marketing['date_subscribed'].dt.dayofweek