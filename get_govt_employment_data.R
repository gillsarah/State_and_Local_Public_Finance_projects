
# data layout https://data.bls.gov/cew/doc/access/csv_data_slices.htm 

library(readxl)
library(dplyr)


# From QCEW Open Data Access RScript Example
# ******************************************************************************************
# qcewGetIndustryData : This function takes a year, quarter, and industry code
# and returns an array containing the associated industry data. Use 'a' for 
# annual averages. Some industry codes contain hyphens. The CSV files use
# underscores instead of hyphens. So 31-33 becomes 31_33. 
# For all industry codes and titles see:
# http://data.bls.gov/cew/doc/titles/industry/industry_titles.htm

qcewGetIndustryData <- function (year, qtr, industry) {
  url <- "http://data.bls.gov/cew/data/api/YEAR/QTR/industry/INDUSTRY.csv"
  url <- sub("YEAR", year, url, ignore.case=FALSE)
  url <- sub("QTR", tolower(qtr), url, ignore.case=FALSE)
  url <- sub("INDUSTRY", industry, url, ignore.case=FALSE)
  read.csv(url, header = TRUE, sep = ",", quote="\"", dec=".", na.strings=" ", skip=0)
}

# ******************************************************************************************

all_industry <- qcewGetIndustryData("2019", "a", "10")

far_w_state_local <- subset(all_industry, (own_code == "2" | own_code == "3") & 
                                    (area_fips == "06000" | area_fips == "32000" | 
                                     area_fips == "41000" | area_fips == "53000"))

###
#Ownership Codes: 
#Local Govt: 3
#State Govt: 2

#State Fips:
#CA "06000"
#NV "32000"
#OR "41000"
#WA "53000"
###
# fips codes https://data.bls.gov/cew/doc/titles/area/area_titles.htm 


# 2019 Annual Survey of State Government Finances Tables
# state revenue and expenditure
# https://www.census.gov/data/tables/2019/econ/state/historical-tables.html 
# url <-  https://www2.census.gov/programs-surveys/state/tables/2019/2019_ASFIN_State_Totals.xlsx

state_fin <- read_xlsx("/Users/Sarah/Documents/GitHub/State_and_Local_Public_Finance_projects/data/2019_ASFIN_State_Totals.xlsx")

far_west_fin <- select(state_fin, "(Thousands of Dollars)", "California", "Nevada", "Oregon", "Washington")

#Alternative via Census: 
# Public Sector Annual Survey
#State and Local Government Employment and Payroll Data: 2017-18
# Table GS00EP03

#Revenue
# State and Local Governmetn Finance by Level of Government: 2017-18
# Table GS00LF01
