
# From QCEW Open Data Access RScript Example
# ******************************************************************************************
# qcewGetAreaData : This function takes a year, quarter, and area argument and
# returns an array containing the associated area data. use 'a' for annual
# averages. 
# For all area codes and titles see:
# http://data.bls.gov/cew/doc/titles/area/area_titles.htm

qcewGetAreaData <- function(year, qtr, area) {
  url <- "http://data.bls.gov/cew/data/api/YEAR/QTR/area/AREA.csv"
  url <- sub("YEAR", year, url, ignore.case=FALSE)
  url <- sub("QTR", tolower(qtr), url, ignore.case=FALSE)
  url <- sub("AREA", toupper(area), url, ignore.case=FALSE)
  read.csv(url, header = TRUE, sep = ",", quote="\"", dec=".", na.strings=" ", skip=0)
}

# ******************************************************************************************
# data layout https://data.bls.gov/cew/doc/access/csv_data_slices.htm 

CAData <- qcewGetAreaData("2019", "a", "06000")

CAstate_local <- subset(CAData, )

###
#Ownership Codes: 
#Local Govt: 3
#State Govt: 2
#Fed Govt: 1
#Total Govt: 8
#Total U.I. Covered (Excludes Federal Government): 9
###
