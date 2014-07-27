# TODO: Add comment
# 
# Author: pacha
###############################################################################

setwd("/Users/pacha/Dropbox/R/getting-and-cleaning-data/quiz2")

#Question 1
#Register an application with the Github API here https://github.com/settings/applications. 
#Access the API to get information on your instructors repositories 
#(hint: this is the url you want "https://api.github.com/users/jtleek/repos"). 
#Use this data to find the time that the datasharing repo was created. What time was it created? 
#This tutorial may be useful (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r). 
#You may also need to run the code in the base R package and not R studio. 

library(httr)
oauth_endpoints("github")
myapp <- oauth_app("github", "3ab313538c301fa31716", "233ec0ebcdfb48f0bb0027f5c2ffef4df7876024")
#Use http://localhost:1410 as the callback url
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)
req <- GET("https://api.github.com/rate_limit", config(token = github_token))
stop_for_status(req)
content(req)
# curl -u Access Token:x-oauth-basic "https://api.github.com/users/jtleek/repos"
BROWSE("https://api.github.com/users/jtleek/repos",authenticate("Access Token","x-oauth-basic","basic"))
# 2013-11-07T13:25:07Z

#Question 2
#The sqldf package allows for execution of SQL commands on R data frames. We will use the sqldf package to practice 
#the queries we might send with the dbSendQuery command in RMySQL. Download the American Community Survey data and load 
#it into an R object called
#acs
#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
#Which of the following commands will select only the data for the probability weights pwgtp1 with ages less than 50?

install.packages("sqldf")
library(sqldf)
acs <- read.csv("getdata_data_ss06pid.csv", header=T, sep=",")
head(acs)
sqldf("select pwgtp1 from acs where AGEP < 50")

#Question 3
#Using the same data frame you created in the previous problem, what is the equivalent function to unique(acs$AGEP)

sqldf("select distinct AGEP from acs")
length(unique(acs$AGEP))
#91

#Question 4
#How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
#http://biostat.jhsph.edu/~jleek/contact.html
#(Hint: the nchar() function in R may be helpful)

hurl <- "http://biostat.jhsph.edu/~jleek/contact.html"
con <- url(hurl)
htmlCode <- readLines(con)
close(con)
sapply(htmlCode[c(10, 20, 30, 100)], nchar)
#45 31 7 25

#Question 5
#Read this data set into R and report the sum of the numbers in the fourth column.
#https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
#Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for
#(Hint this is a fixed width file format)

data <- read.csv("getdata_wksst8110.for", header=T)
head(data)
dim(data)
file_name <- "getdata_wksst8110.for"
df <- read.fwf(file=file_name,widths=c(-1,9,-5,4,4,-5,4,4,-5,4,4,-5,4,4), skip=4)
head(df)
sum(df[, 4])