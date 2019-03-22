#install.packages(c("httr", "jsonlite", "lubridate", "tidyverse"))
library(httr)
library(jsonlite)
library(lubridate)
library(dplyr) #part of the tidyverse

# This call only effects the current session
options(stringsAsFactors = FALSE)

url  <- "http://flutrack.org/results.json"
path <- paste("results.json")

result <- GET(url = url, path = path)
status_code(result)
headers(result)

this.content <- fromJSON(content(result, "text", encoding="UTF-8"))
type <- typeof(this.content$values)

df <- as.data.frame(this.content$values)

print(df)