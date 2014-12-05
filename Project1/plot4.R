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

# Generate a page of 4 graphs (2 x 2) of the following:
#   1. time series line graph of Global Active Power,
#   2. time series line graph of voltage,
#   3. time series line graphs of Sub_metering_1/2/3,
#   4. time series line graph of Global_reactive_power,
#  from Thu 2007-02-01 00:00:00 through Sat 2007-02-03 00:00:00.

# Open PNG graphics device
png(file="plot4.png", width=480, height=480, res=80)

#par(new=T)
par(mfrow=c(2,2))
par(bg="gray")
par(cex.lab=0.75)
par(cex.axis=0.75)

with(subset,
     plot(datetime,
          Global_active_power,
          type="l",
          xlab="",
          ylab="Global Active Power"))

with(subset,
     plot(datetime,
          Voltage,
          type="l",
          xlab="datetime",
          ylab="Voltage"))

minval <- min(min(subset$Sub_metering_1),min(subset$Sub_metering_2),min(subset$Sub_metering_3))
maxval <- max(max(subset$Sub_metering_1),max(subset$Sub_metering_2),max(subset$Sub_metering_3))
xrange <- range(subset$datetime)
yrange <- range(minval,maxval)
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
          col="blue"))

legtxt <- c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
legcol <- c("black","red","blue")
leglty <- c(1,1,1)
legend("topright",
       col=legcol,
       lty=leglty,
       legend=legtxt,
       cex = 0.75,
       ncol=1,
       bty="n",
       xjust=0,
       inset=0.05,
       y.intersp=0.75,
       horiz=FALSE)

with(subset,
     plot(datetime,
          Global_reactive_power,
          type="l",
          xlab="datetime",
          ylab="Global Reactive Power"))

#dev.copy(png, "plot4.png", width=480, height=480)

# Close PNG graphics device
dev.off()

