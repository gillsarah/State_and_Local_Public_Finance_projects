import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

os.chdir('/Users/Sarah/Documents/GitHub/State_and_Local_Public_Finance_projects/State-Finance-Comparison')
df = pd.read_csv(os.path.join('data','far_west_t.csv'))

df.columns


CArev = df.iloc[0:1,2:15]
revbysource = CArev[['Intergovernmental.revenue','Taxes','Current.charge', 
                    'Miscellaneous.general.revenue', 'Utility.revenue','Liquor.stores.revenue']]
taxrev = CArev[['Taxes', 'General.sales', 'Selective.sales', 'License.taxes',
                'Individual.income.tax', 'Corporate.income.tax', 'Other.taxes']]
taxrev_t = pd.DataFrame(np.transpose(taxrev))
taxrev_t = pd.DataFrame(taxrev.transpose())



fig, ax = plt.subplots()
ax.bar(taxrev_t)
plt.show()

fig, ax = plt.subplots()
ax.bar(df['Row.names'], df['General.expenditure'])
plt.show()