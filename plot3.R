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
# household_power_consumption<-read.csv2(file.path(getwd(),'household_power_consumption.txt'), na = '?')

library(dplyr)
#household_power_consumption<-dplyr::mutate(household_power_consumption, datetime=strptime(paste(household_power_consumption$Date , household_power_consumption$Time), "%d/%m/%Y %H:%M:%S"))

household_power_consumption<-dplyr::mutate(household_power_consumption, datetime=paste(household_power_consumption$Date , household_power_consumption$Time))
household_power_consumption$datetime<-as.POSIXct(strptime(household_power_consumption$datetime, "%d/%m/%Y %H:%M:%S"))
household_power_consumption<-tbl_df(household_power_consumption)

household_power_consumption<-filter(household_power_consumption, datetime>=strptime('2007-02-01', '%Y-%m-%d'), datetime<strptime('2007-02-03', '%Y-%m-%d'))

png(filename = file.path(getwd(), 'plot3.png'), width = 480, height = 480)
with(
     select(household_power_consumption, Sub_metering_1, datetime),
     plot(
          datetime, as.numeric(Sub_metering_1), type = "l",
          ylab = 'Energy sub metering',
          xlab = ''
     )
)

with(
     select(household_power_consumption, Sub_metering_2, datetime),
     lines(
          datetime, as.numeric(Sub_metering_2), type = "l",
          col = 'red'
     )
)

with(
     select(household_power_consumption, Sub_metering_3, datetime),
     lines(
          datetime, as.numeric(Sub_metering_3), type = "l",
          col = 'blue'
     )
)

legend(
     'topright',
     legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
     col = c('black', 'red', 'blue'),
     lty = 1
)
dev.off()



