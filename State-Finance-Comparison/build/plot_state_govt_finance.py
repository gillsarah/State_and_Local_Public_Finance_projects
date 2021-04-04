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

# subset df for tax by source
taxbysource = df.iloc[5:11,]

# subset df for revenue by source -not working yet
revbysource = pd.concat(df.iloc[2:5,], df.iloc[6:15,])
revbysource = revbysource.iloc[-5:11,]

def one_state_bar_plot(df, state, savefig = False):
    '''df, already sliced 
    state, string of state name (match column name for that state)
    '''
    # sort by one state's values
    sort_state = df.sort_values(by = state, ascending=True)

    # plot
    fig, ax = plt.subplots()
    ax.barh(sort_state['Unnamed: 0'], sort_state[state])
    # label bars with values
    for i, v in enumerate(sort_state[state]):
        plt.text(v,i, '${:,.0f}'.format(round(v,0)) ) 

    plt.title('Per Capita {} State Tax Revenue by source'.format(state))
    # Adjust layout to make room for the long lables:
    plt.subplots_adjust(left=0.3)
    # clean up
    ax.spines['right'].set_visible(False)
    ax.spines['left'].set_visible(False)
    ax.spines['top'].set_visible(False)
    ax.spines['bottom'].set_visible(False)
    plt.tick_params(bottom=False, labelbottom=False)
    if savefig:
        plt.savefig('Per Capita {} State Tax Revenue by source'.format(state))
    else:
        plt.show()

for v in df.columns[1:]:
    one_state_bar_plot(taxbysource, v)


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