# importing the json library 
import json
import pandas as pd

# load the json file
with open('json_sample.json') as json_data:
    data = json.load(json_data,)

# beautify print the file without keys being sorted alphabetically
print(json.dumps(data, indent=4, sort_keys=False))

# to view what the first customer bought, you can use the print below
print(json.dumps(data['records'][0]['items'],indent=4))

# (optional) identify which page we're on and total number of order pages
print("page "+ str(data['page']),"total "+ str(data['total_pages']),sep="\n")

# use if loop to see how many items each customer bought and use double for loop to display item info
# create blank array for the features we want displayed
orderNumber, orderDate, customer, sku, title, quantity, price   = [],[],[],[],[],[],[]

# sift through each record and add the line item along with customer info onto the blank array
for i in data['records']:
    t = len(i['items'])  #count how many items there are
    x = i['items']
    if t == 0:  #if there are no items, print the customer info but with blank item info
        orderNumber.append(i['orderNumber'])
        orderDate.append(i['orderDate'])
        customer.append(i['customer'])
        sku.append('')
        title.append('')
        quantity.append('')
        price.append('')
    else: 
        for u in x:  #add each item info with customer info onto array
            orderNumber.append(i['orderNumber'])
            orderDate.append(i['orderDate'])
            customer.append(i['customer'])
            sku.append(u['sku'])
            title.append(u['title'])
            quantity.append(u['quantity'])
            price.append(u['price'])

# for i in data order number appends first item
final_array = [orderNumber, orderDate, customer, sku, title, quantity, price] 
zip_array = [*zip(*final_array)]

# preview some of the data
for z in zip_array:
    print(*z, sep=",")

# load the data into a dataframe
df = pd.DataFrame(zip_array, columns = ['orderNumber', 'orderDate', 'customer', 'sku', 'title', 'quantity', 'price'],index=False)
df.to_csv('line_item.csv',sep=',', index=False)