
# employment data
# QCEW data layout https://data.bls.gov/cew/doc/access/csv_data_slices.htm 

# 2019 Annual Survey of State Government Finances Tables
# state revenue and expenditure
# https://www.census.gov/data/tables/2019/econ/state/historical-tables.html 
# url <-  https://www2.census.gov/programs-surveys/state/tables/2019/2019_ASFIN_State_Totals.xlsx


#Alternative via Census: 
# Public Sector Annual Survey
#State and Local Government Employment and Payroll Data: 2017-18
# Table GS00EP03

#Revenue
# State and Local Governmetn Finance by Level of Government: 2017-18
# Table GS00LF01

rm(list=ls())

library(readxl) # to read in the fin excel (may not need once I figure out the API for this census survey)
library(dplyr) # for select
library(tidyverse) # for adding the employment data to the fin data
library(tidycensus) # to get population values (from ACS)

# not sure if this is helpful here (still need full path for read excel)
setwd("/Users/Sarah/Documents/GitHub/State_and_Local_Public_Finance_projects")

### Get State Populations
census_api_key("02641ed95391c28c682941aa913f72a29efdd359")
ACS19var <- load_variables(2019, "acs5", cache = TRUE)

pop <- medinc <- get_acs(geography = "state", 
                         variables = c(population = "B01001_001"), 
                         #state = 'CA', 'WA',
                         year = 2019)


### Government Employment
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

### Revenue and Expend
# 2019 Annual Survey of State Government Finances Tables
# https://www.census.gov/data/tables/2019/econ/state/historical-tables.html
state_fin <- read_xlsx("/Users/Sarah/Documents/GitHub/State_and_Local_Public_Finance_projects/data/2019_ASFIN_State_Totals.xlsx")
far_west_fin <- select(state_fin, "(Thousands of Dollars)", "California", "Nevada", "Oregon", "Washington")

# transpose 
test <- t(far_west_fin)
d2 <- data.frame(test)
colnames(d2) <- test[1,]
# merge
test2 <- merge(d2, pop, by.x=0, by.y="NAME")




# next need to remove trailing 0 from emp data area_fils (or add to pop)
# so can merge -> per capita
# prep emp data for merge
far_w_state_local$area_fips



####
new_fin <- subset(far_w_state_local, own_code == "2")
test <- pivot(new_fin, area_fips, annual_avg_emplvl)



df <- far_west_fin %>%
  add_row("(Thousands of Dollars)" = 'State Employment', "California" = far_w_state_local$annual_avg_emplvl[1])



