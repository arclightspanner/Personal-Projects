import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
data = np.reshape(np.random.randn(20),(10,2)) # 10 training examples
labels = np.random.randint(2, size=10) # 10 labels

X = pd.DataFrame(data)
y = pd.Series(labels)


X_train, X_test, y_train, y_test = train_test_split(X, y,  test_size=test_size, random_state=0)


from sklearn.linear_model import LogisticRegression

model = linear_model.LogisticRegression()
model = model.fit(X_train, y_train)

# Retrieve coefficients: index is the feature name ([0,1] here)
df_coefs = pd.DataFrame(model.coef_[0], index=X.columns, columns = ['Coefficient'])
df_coefs