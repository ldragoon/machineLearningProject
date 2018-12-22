# Tutorials used
# https://www.r-bloggers.com/accessing-apis-from-r-and-a-little-r-programming/
# https://datascienceplus.com/accessing-web-data-json-in-r-using-httr/
# https://cran.r-project.org/web/packages/httr/vignettes/quickstart.html
# API => http://et.water.ca.gov/

install.packages(c("httr", "jsonlite", "lubridate"))
library(httr)
library(jsonlite)
library(lubridate)

# This call only effects the current session
options(stringsAsFactors = FALSE)

# http://et.water.ca.gov/Rest/Index
# Complete String:
# http://et.water.ca.gov/api/data?appKey=XXXXX&targets=95746&startDate=2018-12-01&endDate=2018-12-05
# LIMITED TO CALIFORNIA ZIP CODES
url     <- "http://et.water.ca.gov"
apiKey  <- "XXXXXX"
zipCode <- "95746"
startDate <- "2018-12-01"
endDate <- "2018-12-05"
path    <- paste("api/data?appKey=", apiKey, "&targets=", zipCode, "&startDate=", startDate, "&endDate=", endDate, sep = "")

raw.result <- GET(url = url, path = path)

names(raw.result)

raw.result$status_code

content(raw.result, "text", encoding = "ISO-8859-1")

head(raw.result$content)

this.content <- fromJSON(content(raw.result, "text", encoding="UTF-8"))
print(this.content)
class(this.content)
length(this.content)
this.content[[1]] #the first element
this.content.df <- do.call(what = "rbind", args = lapply(this.content, as.data.frame))
dim(this.content.df)
head(this.content.df)