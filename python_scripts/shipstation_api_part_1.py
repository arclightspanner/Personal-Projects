""" Basic version for shipstation order extraction """

# importing the requests library 
import requests
import json
  
# api-endpoint 
URL = "https://ssapi.shipstation.com/orders/"
  
# defining a params dict for the parameters to be sent to the API 
key = ('<<put your key_1 here>>', '<<put your key_2 here>>')
  
# sending get request and saving the response as response object 
r = requests.get(url = URL, auth = key)
  
# extracting data in json format 
data = r.json()
print(json.dumps(data, indent=2))
print(data['orders'][22]['items'][0]['sku'])

orderNumber,sku = [],[]

for i in data['orders']:
    t = len(i['items'])
    x = i['items']
    if t == 0:
        orderNumber.append(i['orderNumber'])
        sku.append('')
    else:
        for u in x:
            orderNumber.append(i['orderNumber'])
            sku.append(u['sku'])

# for i in data order number appends first item
final_array = [orderNumber,sku] 
zip_array = [*zip(*final_array)]

for z in zip_array:
    print(*z, sep="||")