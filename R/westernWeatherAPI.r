# SETUP - go to Preferences and update the Default Working Directory to be the current project directory and then restart RStudio
# Resources:
# https://geocompr.robinlovelace.net/
# https://www.statmethods.net/input/dates.html
# https://www.cyclismo.org/tutorial/R/time.html
# https://swcarpentry.github.io/r-novice-inflammation/11-supp-read-write-csv/
# https://community.rstudio.com/t/reorder-columns-by-position/18527
# http://astrostatistics.psu.edu/su07/R/html/base/html/strptime.html

# .libPaths() => path to library temp install location
# help.search("some.function") => Super useful!

#install.packages(c("httr", "jsonlite", "lubridate", "tidyverse")) # => uncomment out to reinstall packages
library(httr)
library(jsonlite)
library(lubridate)
library(dplyr)  #part of the tidyverse

# This call only effects the current session
options(stringsAsFactors = FALSE)

url       <- "https://api.westernwx.com"
apiKey		<- "Basic XXXX"
username	<- "XXXX"
password	<- "XXXX"
interval	<- "60" # => 1 hour, 15 => 15 mins, 1440 => 24 hours
stationID	<- "LOC"
startdate	<- format(as.Date(Sys.time()) - 1, "%Y-%m-%dT%H:%M:%S-08:00")
enddate		<- format(Sys.time(), "%Y-%m-%dT%H:%M:%S-08:00")

path <- paste("stationdata/", interval, "/", stationID, "/", startdate, "/", enddate, sep = "")
print(path)

result <- GET(url = url, path = path, add_headers(Authorization = apiKey))
status_code(result)
headers(result)

this.content <- fromJSON(content(result, "text", encoding="UTF-8"))

# type <- typeof(this.content$values)

df <- as.data.frame(this.content$values)

# Create Station Data
if (stationID == "LOC") {
    #Lockford 
} else if (stationID == "LIN") {
    #Linden
} else if (stationID == "LOD") {
    #Lodi
} else if (stationID == "HSM") {
    #Morgan Valley
} else if (stationID == "FPL") {
    #Fair Play
} else if (stationID == "IST") {
    #Ironstone
} else if (stationID == "LAV") {
    #Lava Cap
} else if (stationID == "WPT") {
    #West Point
}

# create Table ID column
if (interval == 60) {
  df <- mutate(df, "*TABLE ID 160" = "160")
  tableID <- 160
} else if (interval == 15) {
  df <- mutate(df, "*TABLE ID 120" = "120")
  tableID <- 120
} else if (interval == 1440) {
  df <- mutate(df, "*TABLE ID 201" = "201")
  tableID <- 201
}
#move the Table ID column to the first position
df <- df %>% select(paste("*TABLE ID", tableID), everything())

datestamp <- as.Date(this.content$day)
timestamp <- ymd_hms(this.content$timestamp)

# create YEAR column
df <- mutate(df, "YEAR" = year(datestamp))
#move the Year column to the second position
#df <- df %>% select(1, "YEAR", everything())

# Correct Header Order
#*TABLE ID 201,YEAR,J-DAY,OBS TIME,AIR MAX,AIR MAX OCCUR,AIR MIN,AIR MIN OCCUR,AIR AVG,RH AVG,
#WIND AVG SPEED,WIND AVG DIR,WIND MAX SPEED,WIND MAX OCCUR,WIND MAX DIR,PRECIP,SOLAR RAD,
#SOIL AVG,ET,DEGDAY,HOURS 32F,HOURS 85F,HOURS 92F,CHILL HOURS,SOIL MOIST,LEAF,BATTERY,,
#DEW POINT,,AIR2 MAX:F,AIR2 MIN:F,AIR2 AVG:F,RH MAX,RH MIN,,,,,,,,,,,,,,,,

df <- mutate(df, "Day"      = format(datestamp, "%d"))
df <- mutate(df, "Julian"   = as.POSIXlt(datestamp, format = "%y-%b-%d")$yday)
df <- mutate(df, "Obs Time" = format(timestamp, "%H%M"))

colnames(df)[colnames(df)=="TempMaxDay"]        <- "Air Max"
colnames(df)[colnames(df)=="TempMaxDayTime"]    <- "Air Max Occur"
colnames(df)[colnames(df)=="TempMinDay"]        <- "Air Min"
colnames(df)[colnames(df)=="TempMinDayTime"]    <- "Air Min Occur"
colnames(df)[colnames(df)=="Temp"]              <- "Air Avg"
colnames(df)[colnames(df)=="RH"]                <- "RH Avg"
colnames(df)[colnames(df)=="RHMaxDay"]          <- "RH Max"
colnames(df)[colnames(df)=="RHMinDay"]          <- "RH Min"
colnames(df)[colnames(df)=="WindSpeed"]         <- "Wind Avg Speed"
colnames(df)[colnames(df)=="WindMaxDayDir"]     <- "Wind Avg Dir"
colnames(df)[colnames(df)=="WindMaxDay"]        <- "Wind Max Speed"
colnames(df)[colnames(df)=="WindMaxDayTime"]    <- "Wind Max Occur"
colnames(df)[colnames(df)=="WindMaxDayDir"]     <- "Wind Max Dir"
colnames(df)[colnames(df)=="SoilAvg"]           <- "Soil Avg"
colnames(df)[colnames(df)=="ET"]                <- "ETo"
colnames(df)[colnames(df)=="CoolingDegreeDays"] <- "DegDay"
colnames(df)[colnames(df)=="HoursTemp32Day"]    <- "Hours 32F"
colnames(df)[colnames(df)=="HoursTemp70To85Day"]<- "Hours 85F"
colnames(df)[colnames(df)=="HoursTemp95Day"]    <- "Hours 92F"
colnames(df)[colnames(df)=="ChillHoursDay"]     <- "Chill Hours"
colnames(df)[colnames(df)=="SoilMoisture"]      <- "Soil Moist"
colnames(df)[colnames(df)=="LeafWetnessDay"]    <- "Leaf:Hours"
colnames(df)[colnames(df)=="BatVoltMinDay"]     <- "Battery"
colnames(df)[colnames(df)=="DewPoint"]          <- "Dew Point"
colnames(df)[colnames(df)=="ChillHoursDay"]     <- "Chill Hours"
colnames(df)[colnames(df)=="PrecipDay"]         <- "Precip"
colnames(df)[colnames(df)=="SolarRad"]          <- "Solar Rad"

print(df)

#write.csv(df, file = "loc-fmt.csv", row.names = FALSE, na = '-6999')