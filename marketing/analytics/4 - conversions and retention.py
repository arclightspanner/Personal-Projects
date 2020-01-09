"""CALCULATE CONVERSION RATE"""
# conversion = converted people count/ marketed people count
import pandas as pd
marketing = pd.read_csv('marketing_new.csv', parse_dates = ['date_served','date_subscribed','date_canceled'])

# Calculate the number of people we marketed to
total = marketing['user_id'].nunique()

# Calculate the number of people who subscribed
subscribers = marketing[marketing['converted'] == True]['user_id'].nunique()

# Calculate the conversion rate
conversion_rate = subscribers/total
print(round(conversion_rate*100, 2), "%")

# retention = subscribed people count/ total number of people converted
# Calculate the number of people who remained subscribed
retained = marketing[marketing['is_retained'] == True]['user_id'].nunique()

# Calculate the retention rate
retention_rate = retained/subscribers
print(round(retention_rate*100, 2), "%")