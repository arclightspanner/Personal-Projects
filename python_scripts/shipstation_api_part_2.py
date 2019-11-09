""" Intermediate version for shipstation order extraction which considers API pagination, 
data stored in pandas can be further pushed into a database """

# importing the requests library
import requests
import json
import pandas as pd

# create function that extracts data from JSON and creates a pandas dataframe
def json_extract(data):
    orderNumber,createDate,sku,name,quantity = [],[],[],[],[]
    for i in data['orders']:
        t = len(i['items'])
        x = i['items']
        if t == 0:
            orderNumber.append(i['orderNumber'])
            createDate.append(i['createDate'])
            sku.append('')
            name.append('')
            quantity.append('')
        else:
            for u in x:
                orderNumber.append(i['orderNumber'])
                createDate.append(i['createDate'])
                sku.append(u['sku'])
                name.append(u['name'])
                quantity.append(u['quantity'])
    final_array = [orderNumber,createDate,sku,name,quantity] 
    zip_array = [*zip(*final_array)]
    df = pd.DataFrame(zip_array, columns = ['orderNumber','createDate','sku','name','quantity'])
    return df
    
# defining a params dict for the parameters to be sent to the API
key = ('<<put your key_1 here>>', '<<put your key_2 here>>')

# obtain the MAX page count then depending on how far back you want to go, determine your starting page
URL1 = "https://ssapi.shipstation.com/orders"
r = requests.get(url = URL1, auth = key)
data_dump = r.json()
sum_page = data_dump['pages'] + 1
sum_page_start = data_dump['pages']-30

# loop through your defined pages and extract data based on your pandas dataframe header
df = pd.DataFrame(columns=['orderNumber','createDate','sku','name','quantity'])
base = 'https://ssapi.shipstation.com/orders?page='

for page in range(sum_page_start,sum_page):
    page_str = str(page)
    URL2 = base + page_str
    r = requests.get(url = URL2, auth = key)
    data_dump = r.json()
    x = json_extract(data_dump)
    df = df.append(x)