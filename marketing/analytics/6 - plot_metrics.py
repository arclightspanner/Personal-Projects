import pandas as pd
import matplotlib.pyplot as plt

marketing = pd.read_csv('marketing_new.csv', parse_dates = ['date_served','date_subscribed','date_canceled'])

language_conversion_rate = marketing.groupby(['language_displayed'])['user_id'].nunique()\
/marketing[marketing['converted'] == True].groupby(['language_displayed'])['user_id'].nunique()

"""BAR CHARTS - CONVERSION BY LANGUAGE"""
# Create a bar chart using language_conversion_rate DataFrame
language_conversion_rate.plot(kind = 'bar')

# Add a title and x and y-axis labels
plt.title('Conversion rate by language\n', size = 16)
plt.xlabel('Language', size = 14)
plt.ylabel('Conversion rate (%)', size = 14)

# Display the plot
plt.show()


"""LINE CHARTS - CONVERSION RATES BY DAYS"""
# Group by date_served and count unique users
total = marketing.groupby(['date_served'])['user_id']\
                     .nunique()

# Group by date_served and calculate subscribers
subscribers = marketing[marketing['converted'] == True]\
                         .groupby(['date_served'])\
                         ['user_id'].nunique()

# Calculate the conversion rate for all languages
daily_conversion_rate = subscribers/total

# Reset index to turn the results into a DataFrame
daily_conversion_rate = pd.DataFrame(daily_conversion_rate.reset_index(0))

# Rename columns
daily_conversion_rate.columns = ['date_served','conversion_rate']

# Create a line chart using daily_conversion_rate
daily_conversion_rate.plot('date_subscribed',
'conversion_rate')

plt.title('Daily conversion rate\n', size = 16)
plt.ylabel('Conversion rate (%)', size = 14)
plt.xlabel('Date', size = 14)

# Set the y-axis to begin at 0
plt.ylim(0)

# Display the plot
plt.show()