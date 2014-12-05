# Script for Coursera "Exploratory Data Analysis"
# Project 1: Plot data from file household_power_consumption.zip
# downloaded from 
# (https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip)
# The assignment requires only data from date 2007-02-01 and 2007-02-02.
# Since read.table does not allow me to check the date while inputing the data,
# I first used grep '/2/2007' and piped the subsetted file to subset_household.txt
# My workspace has both data files.

library(dplyr)
library(lubridate)

# Set workspace to unzipped data's directory
setwd("/Users/belindaswanson/Coursera/ExploratoryDataAnalysis/Projects/Project1")
getwd()
print("The contents in the unzipped data's directory are:")
list.files()

x <- read.csv("subset_household.csv",
              sep=";",
              colClasses = c("character",
                             "character",
                             "numeric",
                             "numeric",
                             "numeric",
                             "numeric",
                             "numeric",
                             "numeric",
                             "numeric"),
              strip.white = TRUE,
              na.strings = c("?",""))

# Confirm data are read in correctly
head(x, n=2)
tail(x, n=2)
length(x)
summary(x)

# Convert Date and Time values to Date/Time value,combining into one field,
# and add result to a column called "datetime" in dataframe x
x$datetime = dmy_hms(paste(as.character(x[,1]), as.character(x[,2]), sep=" "))

# Create a new dataframe based on dataframe x having dates 2007-02-01 through 2007-02-02
subset <- filter(x, x$datetime <= ymd("2007-02-03"))

# Generate a histogram of Global Active Power
par(bg="gray")
with(subset, hist(Global_active_power,
                  main="Global Active Power",
                  xlab="Global Active Power (kilowatts)", 
                  ylab="Frequency", 
                  col="red"))

dev.copy(png, "plot1.png", width=480, height=480)
dev.off()



