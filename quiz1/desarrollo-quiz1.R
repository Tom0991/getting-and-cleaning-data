# TODO: Add comment
# 
# Author: pacha
###############################################################################

library(plyr)
library(XLConnect)
library(XML) 
library(httr) 
library(WriteXLS)
library(data.table)

setwd("/Users/pacha/Dropbox/R/getting-and-cleaning-data/tarea1")

#preguntas 1 y 2
#The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
#and load the data into R. The code book, describing the variable names is here: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
#How many housing units in this survey were worth more than $1,000,000? 

#descargar datos
direccion <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
archivo <- "datos.csv"
download.file(direccion, archivo, method="curl")

#descargar variables
direccion2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf "
variables <- "variables.pdf"
download.file(direccion2, variables, method="curl")

datos <- read.csv("datos.csv")

count(datos$VAL == 24)

#pregunta 3
#Download the Excel spreadsheet on Natural Gas Aquisition Program here: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx
#Read rows 18-23 and columns 7-15 into R and assign the result to a variable called: dat 
#What is the value of: sum(dat$Zip*dat$Ext,na.rm=T) 

direccion3 <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx" 
archivo2 <- "datos2.xlsx"
download.file(direccion3, archivo2, method="curl")
excel.file <- file.path("datos2.xlsx")

datos2 <- readWorksheetFromFile(excel.file, sheet = 1, header = TRUE, startCol = 7, startRow = 18, endCol = 15, endRow = 23)

sum(datos2$Zip*datos2$Ext,na.rm=T) 

#pregunta 4
#Read the XML data on Baltimore restaurants from here: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml
#How many restaurants have zipcode 21231? 

cafile <- system.file("CurlSSL", "cacert.pem", package = "RCurl")

xml.url <- GET(
		"https://d396qusza40orc.cloudfront.net/", 
		path="getdata%2Fdata%2Frestaurants.xml", 
		config(cainfo = cafile, ssl.verifypeer = FALSE)
)
		
xml.file <- xmlTreeParse(xml.url, useInternal = TRUE) 
root.node <- xmlRoot(xml.file)
xmlName(root.node)
names(root.node)
names(rootNode[[1]][[1]])
zipcode <- xpathSApply(root.node,"//zipcode",xmlValue)
count(zipcode == 21231)

#pregunta 5
#The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
#using the fread() command load the data into an R object DT 
#Which of the following is the fastest way to calculate the average value of the variable pwgtp15 broken down by sex using the data.table package?
#rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]
#mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)
#sapply(split(DT$pwgtp15,DT$SEX),mean)
#mean(DT$pwgtp15,by=DT$SEX)
#DT[,mean(pwgtp15),by=SEX]
#tapply(DT$pwgtp15,DT$SEX,mean)

direccion4 <-  "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv" 
archivo3 <- "datos3.csv"
download.file(direccion4, archivo3, method="curl")
datos3 <- fread(input="datos3.csv", sep=",")

system.time(rowMeans(datos3)[datos3$SEX==1])
system.time(rowMeans(datos3)[datos3$SEX==2])

system.time(mean(datos3[datos3$SEX==1,]$pwgtp15))
system.time(mean(datos3[datos3$SEX==2,]$pwgtp15))

system.time(sapply(split(datos3$pwgtp15,datos3$SEX),mean))

system.time(mean(datos3$pwgtp15,by=datos3$SEX))

system.time(datos3[,mean(pwgtp15),by=SEX])

system.time(tapply(datos3$pwgtp15,datos3$SEX,mean))
