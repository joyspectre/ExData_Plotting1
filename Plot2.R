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

##### 2. Change variable class from character to date time, 
# create new DateTime and weekday columns
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

##### 3. Save FebPower as text file

write.table(FebPower, file = "./ExData_Plotting1/FebPower.txt")

########## III. Create plot
# Create 480 by 480 pixel .png plot
# include folder name since plot folder differs from data location
# replace x-axis tick marks with weekday abbreviations

########## 1. Plot 2 
# DateTime on X-axis, Global_active_power on y

png(filename = "./ExData_Plotting1/plot2.png", width = 480, height = 480, units = "px")

# Remove x-axis tick marks with xaxt
with(FebPower, plot(DateTime, Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = "Weekday", main = "Plot 2", xaxt = "n"))

#  rows 1, 1441, and 2880 correspond to values
# "2007-02-01 00:00:00 UTC" "2007-02-02 00:00:00 UTC" "2007-02-02 23:59:00 UTC"
# correspond to start of Thu, Fri, and end of Fri; replace axis tick
# marks with Thu Fri Sat
axis(1, at = c(FebPower[1, 10], FebPower[1441, 10], FebPower[2880, 10]), labels = c("Thu", "Fri", "Sat"))

# close png graphics device to see plot
dev.off()

########## END
