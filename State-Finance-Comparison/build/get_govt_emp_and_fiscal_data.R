#looking at the "Far West" region of the US -Bureau of Economic Analysis definition of
# Far West: "includes" CA, OR, WA and NV (so I should check)

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
library(dplyr) # for select and summarize_all and pipe
library(tidyverse) # for adding the employment data to the fin data
library(tidycensus) # to get population values (from ACS)
library(reshape2) # to reshape the employment df

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

far_w_state_local <- subset(all_industry, (own_code == "0" | own_code == "2" | own_code == "3") & 
                                    (area_fips == "06000" | area_fips == "32000" | 
                                     area_fips == "41000" | area_fips == "53000"))
###
#Ownership Codes: 
#Total Covered: 0
#Local Govt: 3
#State Govt: 2

#State Fips:
#CA "06000"
#NV "32000"
#OR "41000"
#WA "53000"
###
# fips codes https://data.bls.gov/cew/doc/titles/area/area_titles.htm 

# make table with just average annual employment levles and these as % of total
avg_government_employment <- function (far_w_state_local) {

  govt_employment <- dcast(far_w_state_local, area_fips ~ own_code, value.var = "annual_avg_emplvl")
  colnames(govt_employment) <- c('GEOID','total_employment', 'state_govt_emp', 'local_govt_emp')
  govt_employment$total_govt_emp <- govt_employment$state_govt_emp + govt_employment$local_govt_emp
  govt_employment$govt_as_perc_total <- govt_employment$total_govt_emp/govt_employment$total_employment
  govt_employment$local_emp_as_perc_total <- govt_employment$local_govt_emp/govt_employment$total_employment
  govt_employment$state_emp_as_perc_total <- govt_employment$state_govt_emp/govt_employment$total_employment
  # make GEOID match the Census table GEOID format
  govt_employment$GEOID <- sub("000", "", as.character(govt_employment$GEOID ))
  # https://stackoverflow.com/questions/63212813/how-to-remove-trailing-zeros-in-r-dataframe 
  return(govt_employment)
}


### Revenue and Expend
# 2019 Annual Survey of State Government Finances Tables
# https://www.census.gov/data/tables/2019/econ/state/historical-tables.html
state_fin <- read_xlsx("/Users/Sarah/Documents/GitHub/State_and_Local_Public_Finance_projects/data/2019_ASFIN_State_Totals.xlsx")
far_west_fin <- select(state_fin, "(Thousands of Dollars)", "California", "Nevada", "Oregon", "Washington")

per_capita_state_finance <- function (far_west_fin) {
  
  # transpose 
  transposed <- t(far_west_fin)
  colnames(transposed)<- transposed[1,]
  d2 <- data.frame(transposed)
  colnames(d2) <- transposed[1,]

  # merge 
  test2 <- merge(transposed, pop, by.x=0, by.y="NAME") 

  # remove untitled columns (and columns w/o a use)
  not_blankcolname <- c()
  for(i in colnames(test2)){
    if(!is.na(i)){
      not_blankcolname<-append(not_blankcolname,i)
   }
  } 

  test3 <- test2%>%
    subset(select = c(not_blankcolname)) %>%
    subset(select = -c(variable, moe)) 

  # address data type problem created by transpose
  i <- c(2:49)
  test4 <- apply(test3[,i], 2, function(x) as.numeric(as.character(x)))
  # https://statisticsglobe.com/convert-data-frame-column-to-numeric-in-r 

  per_cap <- data.frame(test4/test4[,48])

  #put statenames and GEOID back
  per_cap$Row.names <-test2$Row.names
  per_cap$GEOID <- test2$GEOID
  
  return(per_cap)
}


# call the fn -> govt emp df
govt_employment<- avg_government_employment(far_w_state_local)

# call the fn -> per cappita govt finances
per_cap <- per_capita_state_finance(far_west_fin)

# merge govt finances and govt emp
merged <- merge(per_cap, govt_employment, by = "GEOID")

# add averages
averages_row <- function(df){
  averages <- summarize_all(df, mean)
  
  use_df<- df %>%
    rbind(averages)
  return(use_df)
}

use_df <- averages_row(merged)

use_df[5,49] <- "Far West Average"

write.csv(use_df, 
          "/Users/Sarah/Documents/GitHub/State_and_Local_Public_Finance_projects/data/far_west.csv",
          row.names = FALSE)

######
#sapply(far_west_fin,class)
#sapply(use_df, class)

##### Tables
# breaking up df into smaller dfs for easier viewing/comparison

# Employment table
# caution: relies on the order of states being the same
emp <- cbind(govt_employment, per_cap$Row.names)

relative_emp <- emp[,6:9]
# order by govt as percent of employment
# https://www.guru99.com/r-sort-data-frame.html
relative_emp_ordered <- relative_emp[order(relative_emp$govt_as_perc_total, decreasing = TRUE),]

# add far west avg
relative_emp_ordered1 <- averages_row(relative_emp_ordered)


relative_emp_ordered1[5,4] <- "Far West Average"
row.names(relative_emp_ordered1) <- relative_emp_ordered1$`per_cap$Row.names`
relative_emp_ordered1 <- relative_emp_ordered1[,1:3]

relative_emp_table <- t(relative_emp_ordered1)
row.names(relative_emp_table) <- c("State and Local Government as % of Total Employment", 
                                   "Local Government as % of Total Employment",
                                   "State Government as % of Total Employment")

###
# Revenue
revenue <- per_cap[,1:15]
revenue <- cbind(revenue, per_cap$Row.names)

# order by total revenue
revenue_ordered <- revenue[order(revenue$Total.revenue, decreasing = TRUE),]

# Compare total Revenue

# Table for each state with revenue by source, decreasing order

# Compare Total expend

# Table for each state with expend by source, decreasing order


