# TODO: Add comment
# 
# Author: pacha
###############################################################################

setwd("/Users/pacha/Dropbox/R/getting-and-cleaning-data/quiz3")

#QUESTION 1
#The American Community Survey distributes downloadable data about United States communities. 
#Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
#and load the data into R. The code book, describing the variable names is here:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
#Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 
#worth of agriculture products. Assign that logical vector to the variable agricultureLogical. 
#Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE. 
#which(agricultureLogical) What are the first 3 values that result?

library(httr) 

direccion <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
archivo <- "ss06hid.csv"
download.file(direccion, archivo, method="curl")
datos <- read.csv("ss06hid.csv")
logicalvector <- datos$ACR==3 & datos$AGS==6
first3 <- which(logicalvector)[1:3] # which() treats NAs as FALSE
first3

#QUESTION2
#Using the jpeg package read in the following picture of your instructor into R
#https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
#Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 
#(some Linux systems may produce an answer 638 different for the 30th quantile)

library(jpeg)

direccion2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
archivo2 <- "jeff.jpg"
download.file(direccion2, archivo, method="curl")
foto <- readJPEG("jeff.jpg", native = TRUE)
quantile(foto)

#QUESTION3
#Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
#Load the educational data from this data set:
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
#Match the data based on the country shortcode. How many of the IDs match? 
#Sort the data frame in descending order by GDP rank (so United States is last). 
#What is the 13th country in the resulting data frame?
#Original data sources:
#http://data.worldbank.org/data-catalog/GDP-ranking-table
#http://data.worldbank.org/data-catalog/ed-stats

library(data.table)

direccion3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
archivo3 <- "GDP.csv"
download.file(direccion3, archivo, method="curl")
GDP <- data.table(read.csv("GDP.csv", skip = 4, nrows = 191))
GDP <- GDP[X != ""]
GDP <- GDP[, list(X, X.1, X.3, X.4)]
setnames(GDP, c("X", "X.1", "X.3", "X.4"), c("CountryCode", "rankingGDP", "Long.Name", "GDP"))

direccion4 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
archivo4 <- "EDSTATS_Country.csv"
download.file(direccion4, archivo, method="curl")
EDSTATS <- data.table(read.csv("EDSTATS_Country.csv"))

data2 <- merge(GDP, EDSTATS, all = TRUE, by = c("CountryCode"))

sum(!is.na(unique(data2$rankingGDP)))

data2[order(rankingGDP, decreasing = TRUE), list(CountryCode, Long.Name.x, Long.Name.y, rankingGDP, GDP)][13]

#QUESTION4
#What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group? 

data2[, mean(rankingGDP, na.rm = TRUE), by = Income.Group]

#QUESTION5
#Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. 
#How many countries are Lower middle income but among the 38 nations with highest GDP?

breaks <- quantile(data2$rankingGDP, probs = seq(0, 1, 0.2), na.rm = TRUE)
data2$quantileGDP <- cut(data2$rankingGDP, breaks = breaks)
data2[Income.Group == "Lower middle income", .N, by = c("Income.Group", "quantileGDP")]
