url = 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
filename = file.path(getwd(), 'household_power_consumption.zip')

if (!file.exists(filename))
{
     download.file(url, filename)
}

if (!file.exists(file.path(getwd(), 'household_power_consumption.txt')))
{
     unzip(filename)
}

library(readr)
household_power_consumption<-readr::read_csv2(file.path(getwd(),'household_power_consumption.txt'), na = '?', col_types = 'ccccccccc')

library(dplyr)
#household_power_consumption<-dplyr::mutate(household_power_consumption, datetime=strptime(paste(household_power_consumption$Date , household_power_consumption$Time), "%d/%m/%Y %H:%M:%S"))

household_power_consumption<-dplyr::mutate(household_power_consumption, datetime=paste(household_power_consumption$Date , household_power_consumption$Time))
household_power_consumption$datetime<-as.POSIXlt(strptime(household_power_consumption$datetime, "%d/%m/%Y %H:%M:%S"))
household_power_consumption<-tbl_df(household_power_consumption)

filter(household_power_consumption, Date>='2007-02-01')




