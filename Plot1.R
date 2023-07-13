#setwd ("to/you/working/directory")

########## I. Download and unzip file, get a rough idea of data structure

# Save URL as object
Proj1Url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

#download zip file, using Windows so set mode = "wb" to avoid issues later
download.file(Proj1Url, destfile = "HousePower.zip", mode = "wb")

#unzip file, do not overwrite zipped file
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

########## III. Create Plot 1
# Create 480 by 480 pixel .png plot
# include folder name since plot folder differs from data location
########## 1. Plot 1 
# red histogram 

png(filename = "./ExData_Plotting1/plot1.png", width = 480, height = 480, units = "px")

hist(FebPower$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Plot 1: Global Active Power")

# close png graphics device to see plot
dev.off()

########## END