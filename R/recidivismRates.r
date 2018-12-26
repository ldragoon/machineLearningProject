# https://catalog.data.gov/dataset

# Helpful Links
# https://datascienceplus.com/accessing-web-data-json-in-r-using-httr/
# https://www.povertyactionlab.org/sites/default/files/r-cheat-sheet.pdf
# http://zevross.com/blog/2015/02/12/using-r-to-download-and-parse-json-an-example-using-data-from-an-open-data-portal/
# https://stackoverflow.com/questions/35491525/importing-json-data-in-r-to-be-saved-as-dataframe

#install.packages(c("httr", "jsonlite", "rlist"))

library(httr)
library(jsonlite)
library(rlist)
library(dplyr)
library(tidyr)
library(purrr)

# API Requests
resp <- GET("https://data.iowa.gov/api/views/mw8r-vqy4/rows.json?accessType=DOWNLOAD")

http_type(resp) # this method verifies that the response is error free for processing
http_status(resp)

if (http_error(resp) == FALSE) {
  
  data.char <- rawToChar(resp$content)
  data.flat <- jsonlite::fromJSON(data.char, flatten = TRUE)
  
  myMeta <- data.flat$meta
  myData <- data.flat$data
  
  # myColumnList <- myMeta$view$columns$name
  # nrow(myData)
  # ncol(myData)
  
  json_data_frame <- as.data.frame(myData)
  print(json_data_frame)
  
}
