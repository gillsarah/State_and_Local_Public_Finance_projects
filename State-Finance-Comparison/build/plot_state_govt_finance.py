import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

os.chdir('/Users/Sarah/Documents/GitHub/State_and_Local_Public_Finance_projects/State-Finance-Comparison')
df = pd.read_csv(os.path.join('data','far_west_t.csv'))

df.columns
df['Unnamed: 0']
# clean up row title formatting
df['Unnamed: 0'] = df['Unnamed: 0'].apply(lambda x: x.replace(".", " "))
df['Unnamed: 0'] = df['Unnamed: 0'].apply(lambda x: x.title())

# subset df
taxbysource = df.iloc[5:11,]

# sort by one state's values
sort_CA = taxbysource.sort_values(by = 'California', ascending=True)

# plot
fig, ax = plt.subplots()
ax.barh(sort_CA['Unnamed: 0'], sort_CA['California'])
# label bars with values
for i, v in enumerate(sort_CA['California']):
    plt.text(v,i, '${:,.0f}'.format(round(v,0)) ) #0:.0f

# Adjust layout to make room for the long lables:
plt.subplots_adjust(left=0.3)
ax.spines['right'].set_visible(False)
ax.spines['left'].set_visible(False)
ax.spines['top'].set_visible(False)
ax.spines['bottom'].set_visible(False)
plt.tick_params(bottom=False, labelbottom=False)
plt.show()



# out of date
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