# Moving around a few columns to make the data set easier to process
# Original data set can be downloaded from here: https://covid19dataproject.org/data/

# import needed library
library(dplyr)

# import data and check it
data <- read.csv("/Users/YOUR NAME/Desktop/Coronavirus_by_County.csv", header=TRUE)
data[is.na(data)] <- 0 # replace any missing values with 0 to be consistant with data collection measures
days = (ncol(data)-3)/4 # number of days measured
locations = nrow(data) # number of states and counties measured

# repeat the locations for as many days as are measured
fips = rep(data$fips, times = days)
county = rep(data$county, times = days)
state = rep(data$state, times = days)

# get the first date measured
first = substr(colnames(data)[4], nchar(colnames(data)[4])-5, nchar(colnames(data)[4]))
# get the last date measured
last = substr(colnames(data)[ncol(data)], nchar(colnames(data)[ncol(data)])-5, nchar(colnames(data)[ncol(data)]))

# format dates
first = as.Date(paste(substr(first,1,2), substr(first,3,4), substr(first,5,6), sep="/"), format = "%m/%d/%y")
last = as.Date(paste(substr(last,1,2), substr(last,3,4), substr(last,5,6), sep="/"), format = "%m/%d/%y")

# locations variable to repeat each day by the number of states and counties measured
date = rep(seq(first, last, by="days"), each = locations)

# initialize empty variable vectors
tstpos = c()
pbpos = c()
mort = c()
pbmort = c()

# produces a vector of true/false for column name matches
# credit: https://stackoverflow.com/questions/18587334/subset-data-to-contain-only-columns-whose-names-match-a-condition
loc.tstpos = grepl("^tstpos_", names(data))
loc.pbpos = grepl("^pbpos_", names(data))
loc.pbmort = grepl("^pbmort_", names(data))
loc.mort = grepl("^mort_", names(data))

# for debug purposes, ensure length of loc.measure is the same for all four, and the same number of True/False
# number length for each should be exactly equal to ncol(data)
# number True for each should be exactly equal to variable "days"
length(loc.tstpos)
sum(loc.tstpos)
length(loc.pbpos)
sum(loc.pbpos)
length(loc.pbmort)
sum(loc.pbmort)
length(loc.mort)
sum(loc.mort)

# for example debugging purposes: where is pbmort missing a column?
# creates a sequence of indexes where pbmort should exist, use this to match against the locations the loop picks up
# debug = seq(from = 7, to = days, by = 4)
# j = 1

# using the boolean vectors, append the correct columns to the end of the vector of the variable
for (i in 1:ncol(data)) {
  if (loc.tstpos[i] == TRUE) {
    tstpos = append(tstpos, data[,i], after = length(tstpos))
  } else if (loc.pbpos[i] == TRUE) {
    pbpos = append(pbpos, data[,i], after = length(pbpos))
  } else if (loc.pbmort[i] == TRUE) {
    pbmort = append(pbmort, data[,i], after = length(pbmort))
    # example debugging continued:
    # cat will print out the column name, the location of the column, and where the column should be to the shell
    # compare the two to see where the index gets thrown off and fix it from there
    # cat("pbmort", i, debug[j], "\n")
    # j = j+1
  } else if (loc.mort[i] == TRUE) {
    mort = append(mort, data[,i], after = length(mort))
  }
}

# ensure that all variables are the same length or you cannot make a data frame or CSV 
length(fips)
length(county)
length(state)
length(date)
length(tstpos)
length(pbpos)
length(mort)
length(pbmort)

# create a new data frame with the properly organized data
newdat = data.frame(fips, county, state, date, tstpos, pbpos, mort, pbmort)

# write to csv
write.csv(newdat,"/Users/YOUR NAME/Desktop/covid.csv", row.names = FALSE)
