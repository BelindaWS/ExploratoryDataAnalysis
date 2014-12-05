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

# Generate a time-series line graphs of Sub_metering_1/2/3
# from Thu 2007-02-01 00:00:00 through Sat 2007-02-03 00:00:00,
# all appearing in the same panel.
par(new=T)
par(bg="gray")
par(cex.lab=0.75)
par(cex.axis=0.75)
minval <- min(min(subset$Sub_metering_1),min(subset$Sub_metering_2),min(subset$Sub_metering_3))
maxval <- max(max(subset$Sub_metering_1),max(subset$Sub_metering_2),max(subset$Sub_metering_3))
xrange <- range(subset$datetime)
yrange <- range(minval,maxval)
par(new=T)
plot(xrange,
     yrange,
     type="n",
     xlab="",
     ylab="Energy sub metering")

par(new=F)
with(subset,
     lines(datetime,
          Sub_metering_1,
          ylab="",
          col="black"))

par(new=F)
with(subset,
     lines(datetime,
          Sub_metering_2,
          ylab="",
          col="red"))

par(new=F)
with(subset,
     lines(datetime,
          Sub_metering_3,
          ylab="",
          col="blue"),)

legtxt <- c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
legcol <- c("black","red","blue")
leglty <- c(1,1,1)
legend("topright",
       col=legcol,
       lty=leglty,
       legend=legtxt,
       cex = 0.75,
       ncol=1,
       y.intersp = 0.5,
       horiz=FALSE)

dev.copy(png, "plot3.png", width=480, height=480)
dev.off()

