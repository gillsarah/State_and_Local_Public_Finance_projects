
# to request data from BLS
import urllib.request
import urllib

os.chdir('/Users/Sarah/Documents/Github/State_and_Local_Public_Finance_projects/data')

# From QCEW Open Data Access: Sample Code 
# https://data.bls.gov/cew/doc/access/data_access_examples.htm#RSCRIPT 

# This function takes a raw csv string and splits it into
# a two-dimensional array containing the data and the header row of the csv file
# a try/except block is used to handle for both binary and char encoding
def qcewCreateDataRows(csv):
    dataRows = []
    try: dataLines = csv.decode().split('\r\n')
    except er: dataLines = csv.split('\r\n');
    for row in dataLines:
        dataRows.append(row.split(','))
    return dataRows

def qcew_get_area_data(year,qtr,area):
    '''
    year: is string 4 didget year, qtr: string 1-4 or a for annual avg, area: string FIPS
    '''
    urlPath = "http://data.bls.gov/cew/data/api/{}/{}/area/{}.csv".format(year,
                                                                          qtr.lower(),
                                                                          area)
    httpStream = urllib.request.urlopen(urlPath)
    csv = httpStream.read()
    httpStream.close()
    return qcewCreateDataRows(csv)


