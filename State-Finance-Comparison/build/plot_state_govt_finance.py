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
revbysource = pd.concat([df.iloc[2:5,], df.iloc[11:15,]], axis = 0)
revbysource

citation_text = "Data from US Census Bureau, 2019 Annual Survey of State Governments"

def add_citation_text(ax, text):
    # add citation text to the bottom left
    plt.text(0.00, -0.05, text, fontsize = 8,
             ha='left', transform=ax.transAxes, wrap = True)
    
    #https://stackoverflow.com/questions/43087087/matplotlib-set-the-limits-for-text-wrapping


def one_state_bar_plot(df, state, modifyer = '', adjust_left = 0.3, savefig = False, cite_source = False):
    '''df, already sliced 
    state, string of state name (match column name for that state)
    modifyer, text to modify the "Revenue" in the title
    adjust_left, float to adjust plot left to maek room for long y-tick lables
    '''
    # sort by one state's values
    sort_state = df.sort_values(by = state, ascending=True)

    # plot
    fig, ax = plt.subplots()
    ax.barh(sort_state['Unnamed: 0'], sort_state[state])
    # label bars with values
    for i, v in enumerate(sort_state[state]):
        plt.text(v,i, '${:,.0f}'.format(round(v,0)) ) 

    plt.title('{} State Per Capita {}Revenue by source'.format(state, modifyer))
    # Adjust layout to make room for the long lables:
    plt.subplots_adjust(left=adjust_left)

    # clean up
    ax.spines['right'].set_visible(False)
    ax.spines['left'].set_visible(False)
    ax.spines['top'].set_visible(False)
    ax.spines['bottom'].set_visible(False)
    plt.tick_params(bottom=False, labelbottom=False)

    if cite_source:
        add_citation_text(ax=ax, text = citation_text)

    if savefig:
        plt.savefig('{} State Per Capita {}Revenue by source'.format(state, modifyer))
    else:
        plt.show()

for v in df.columns[1:]:
    one_state_bar_plot(taxbysource, v, modifyer = 'Tax ', cite_source = True)

for v in df.columns[1:]:
    one_state_bar_plot(revbysource, v, adjust_left = 0.4, cite_source = True)


'''
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
'''