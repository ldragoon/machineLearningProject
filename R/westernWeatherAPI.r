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

url		    <- "https://api.westernwx.com"
apiKey		<- "Basic XXXX"
username	<- "XXXX"
password	<- "XXXX"
interval	<- "60" # => 1 hour, 15 => 15 mins, 1440 => 24 hours
stationID	<- "XXX"
startdate	<- format(as.Date(Sys.time()) - 1, "%Y-%m-%dT%H:%M:%S-08:00")
enddate		<- format(Sys.time(), "%Y-%m-%dT%H:%M:%S-08:00")

path <- paste("stationdata/", interval, "/", stationID, "/", startdate, "/", enddate, sep = "")

result <- GET(url = url, path = path, add_headers(Authorization = apiKey))
status_code(result)
headers(result)

this.content <- fromJSON(content(result, "text", encoding="UTF-8"))

# type <- typeof(this.content$values)

df <- as.data.frame(this.content$values)

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

df <- mutate(df, "Day"      = format(datestamp, "%d"))
df <- mutate(df, "Julian"   = as.POSIXlt(datestamp, format = "%y-%b-%d")$yday)
df <- mutate(df, "Obs Time" = format(timestamp, "%H%M"))

colnames(df)[colnames(df)=="TempMaxDay"] <- "Air Max"
colnames(df)[colnames(df)=="TempMinDay"] <- "Air Min Occur"
colnames(df)[colnames(df)=="TempMinDay"] <- "Air Min"
colnames(df)[colnames(df)=="TempMinDayTime"] <- "Air Min Occur"
colnames(df)[colnames(df)=="Temp"] <- "Air Avg"
colnames(df)[colnames(df)=="RH"] <- "RH Avg"

names(df) <- toupper(names(df))

print(df)

#write.csv(df, file = "loc-fmt.csv", row.names = FALSE, na = '-6999')