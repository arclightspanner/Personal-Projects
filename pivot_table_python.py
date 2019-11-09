import pandas as pd
import numpy as np

#read the raw_data file
df = pd.read_csv("sales_pivot.csv")

#define pivot table structure and add values,functions
table = pd.pivot_table(df, values=["Quantity","Price"], index = ['Year'], columns=["Type"],
aggfunc = {"Price":[np.mean],"Quantity":[np.sum]}
)

#save results as csv
table.to_csv("table.csv")