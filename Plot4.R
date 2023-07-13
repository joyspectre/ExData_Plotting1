#setwd ("to/you/working/directory")

########## I. Download and unzip file, get a rough idea of data structure

# Save URL as object
Proj1Url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#download zip file, using Windows so set mode = "wb" to avoid issues later
download.file(Proj1Url, destfile = "HousePower.zip", mode = "wb")

#unzip file
unzip("HousePower.zip", exdir = ".", overwrite = FALSE, list = FALSE)

########## II. Prepare data for plots
## BEFORE setting na.strings:
#Column Global_active_power has 25979 "?"
#Column Global_reactive_power has 25979 "?"
#Column Voltage has 25979 "?"
#Column Global_intensity has 25979 "?"
#Column Sub_metering_1 has 25979 "?"
#Column Sub_metering_2 has 25979 "?"
# 25979 total NA
# All other columns have no "?"
# sum of "?" and NAs = 181853

##### 1. Read and subset file

# read file, first row contain column names so use header = TRUE, specify separator as ";", replace "?" with NA
AllPower1 <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", na.strings = "?")
# 2,075,259 rows and 9 columns, "?" replaced by NA, 181853 total NA

# Subset AllPower1 data frame, want only data from Feb 1 2007 or Feb 2 2007
FebPower <- subset(AllPower1, Date == "1/2/2007" | Date == "2/2/2007")
# 2880 rows, 9 columns, no "?", no NA

# Remove AllPower1 data frame from Environment since we don't need it anymore
rm(AllPower1)

##### 2. Change variable class from character to date time, create new DateTime column
# Feb 1 2007 was a Thursday, Feb 2 2007 was a Friday

# Create date time column by combining date and time variables
FebPower$DateTime <- paste(FebPower$Date, FebPower$Time)

# Change variable class from character to date time
library(lubridate)

FebPower$DateTime <- dmy_hms(FebPower$DateTime)
FebPower$Date <- dmy(FebPower$Date)

# Create column with abbreviated weekday name
FebPower$WDay <- wday(FebPower$Date, label = TRUE, abbr = TRUE)

# Check data structure
str(FebPower)
# FebPower has 2880 rows, 11 variables
# col classes 1 = date, 2 = chr, 3 - 9 = numeric, 10 = POSIXct, 11 = factor

########## III. Create plot
# Create 480 by 480 pixel .png plot
# include folder name since plot folder differs from data location
## Re-label x-axis by removing original x-axis ticks using xaxt = "n" within
# plot(), then using axis() function to add new weekday tick labels
#  rows 1, 1441, and 2880 correspond to values
# "2007-02-01 00:00:00 UTC" "2007-02-02 00:00:00 UTC" "2007-02-02 23:59:00 UTC"
# correspond to start of Thu, Fri, and end of Fri; replace axis tick
# marks with Thu Fri Sat

########## 1. Plot 4
# default mar = c(5, 4, 4, 2) -- inner margins, which determines distance
# between plotting areas

png(filename = "./ExData_Plotting1/plot4.png", width = 480, height = 480, units = "px")

# set plot area parameters
par(mfrow = c(2,2), mar = c(3, 4, 1, 2), oma = c(1, 0, 1, 0))

with(FebPower, {
  
  #plot 1
  plot(DateTime, Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = "", xaxt = "n")
  axis(1, at = c(FebPower[1, 10], FebPower[1441, 10], FebPower[2880, 10]), labels = c("Thu", "Fri", "Sat"))
  
  #plot 2
  plot(DateTime, Voltage, type = "l", ylab = "Voltage (volt)", xlab = "", xaxt = "n")
  axis(1, at = c(FebPower[1, 10], FebPower[1441, 10], FebPower[2880, 10]), labels = c("Thu", "Fri", "Sat"))
  
  #plot 3
  {
    plot(DateTime, Sub_metering_1, type = "n", xlab = "", ylab = "", xaxt = "n")
    lines(DateTime, Sub_metering_1, type = "l")
    lines(DateTime, Sub_metering_2, type = "l", col = "red")
    lines(DateTime, Sub_metering_3, type = "l", col = "blue")
    title(ylab = "Energy sub metering")
    legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n", cex = 0.8)
    axis(1, at = c(FebPower[1, 10], FebPower[1441, 10], FebPower[2880, 10]), labels = c("Thu", "Fri", "Sat"))
  }
  
  #plot 4
  plot(DateTime, Global_reactive_power, type = "l", ylab = "Global Reactive Power (kilowatts)", xlab = "", xaxt = "n")
  axis(1, at = c(FebPower[1, 10], FebPower[1441, 10], FebPower[2880, 10]), labels = c("Thu", "Fri", "Sat"))
  
  # Overall x-axis label for all four graphs
  mtext("Weekday", side = 1, outer = TRUE)
  # Overall graph title 
  mtext("Plot 4", side = 3, outer = TRUE)
  
})

dev.off()

########## END

