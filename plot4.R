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

png(filename = file.path(getwd(), 'plot4.png'), width = 480, height = 480)
par(mfrow = c(2,2), mar=c(4,4,2,4))
#plot1
with(
     select(household_power_consumption, Global_active_power, datetime),
     plot(
          datetime, as.numeric(Global_active_power), type = "l",
          ylab = 'Global Active Power',
          xlab = '',
          cex.lab=0.8,
          cex.axis=0.8
     )
)
#plot2
with(
     select(household_power_consumption, Voltage, datetime),
     plot(
          datetime, as.numeric(Voltage), type = "l",
          ylab = 'Voltage',
          xlab = 'datetime',
          cex.lab=0.8,
          cex.axis=0.8
     )
)
#plot3
with(
     select(household_power_consumption, Sub_metering_1, datetime),
     plot(
          datetime, as.numeric(Sub_metering_1), type = "l",
          ylab = 'Energy sub metering',
          xlab = '',
          cex.lab=0.8,
          cex.axis=0.8
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
     lty = 1,
     cex=0.7,
     bty="n"
)
#plot4
with(
     select(household_power_consumption, Global_reactive_power, datetime),
     plot(
          datetime, as.numeric(Global_reactive_power), type = "l",
          ylab = 'Global Reactive Power',
          xlab = 'datetime',
          cex.lab=0.8,
          cex.axis=0.8
     )
)
dev.off()



