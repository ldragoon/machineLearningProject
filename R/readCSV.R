# This small project is the first time I was able to help a co-worker using the ~Power of R~ :)
# Date manipulation package
# http://dirk.eddelbuettel.com/code/anytime.html
#install.packages(c("lubridate"))
library(lubridate)

# Get the absolute path of an input file in R
# https://stackoverflow.com/questions/13311180/how-do-i-get-the-absolute-path-of-an-input-file-in-r
#dir <- "."
#allFiles <- list.files(dir)
#for (f in allFiles) {
#  print(paste(normalizePath(dirname(f)), fsep = .Platform$file.sep, f, sep = ""))
#}

MergedDateCol <- read.csv(file = '../date_range_test_file.csv', stringsAsFactors = FALSE, strip.white = TRUE, sep = ',')
# https://data-flair.training/blogs/r-list-tutorial/
#print(typeof(MergedDateCol$Date))

# https://www.r-bloggers.com/converting-a-list-to-a-data-frame/
df <- as.data.frame(MergedDateCol)
#print(typeof(df$Date))

# original file contains mixed date formats
# eg => 6/7/11 12:00 AM, 12/28/2014 20:26:26
# https://www.rdocumentation.org/packages/lubridate/versions/1.7.4/topics/parse_date_time (look at 'Examples')
df$Date <- parse_date_time(df$Date, c("mdY HMS","mdy HM"))
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/strptime.html
df$Date <- year(df$Date)
write.csv(df, file = 'data/cleaned_dateformat.csv')

# Additional Reading => http://biostat.mc.vanderbilt.edu/wiki/pub/Main/ColeBeck/datestimes.pdf