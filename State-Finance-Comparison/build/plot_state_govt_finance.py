import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

os.chdir('/Users/Sarah/Documents/GitHub/State_and_Local_Public_Finance_projects/State-Finance-Comparison')
df = pd.read_csv(os.path.join('data','far_west.csv'))

df.columns

CA_df = df.loc[[0,4]]


fig, ax = plt.subplots()
ax.bar(df['Row.names'], df['General.expenditure'])
plt.show()