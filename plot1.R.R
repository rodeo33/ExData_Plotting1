library(dplyr)

##Read data from input file
##Since data in file is ordered on date, we are skipping rows till 31st Jan 2007
## Each row corresponds to a minute
##Total rows for two days= 48 Hr X 60 Mins
edata<-read.table("household_power_consumption.txt",na.strings = "?",sep=";",
                  stringsAsFactors = F,
                  skip=grep("31/1/2007;23:59:00", readLines("household_power_consumption.txt")),nrows=2880)
header<- read.table("household_power_consumption.txt",sep=";",nrows=1, stringsAsFactors = F)
edata<-as.data.frame(edata)
edata<-edata[complete.cases(edata),]
colnames(edata)<-header[1,]

##concat Date and Time to create one column
edata<-mutate(edata,dt=paste(Date,Time))
edata<-transform(edata, dt =as.POSIXlt(strptime(dt,"%d/%m/%Y %H:%M:%S")))

##open png device
png(file="plot1.png")

hist(edata$Global_active_power,col="red",main="Global Active Power"
     ,xlab = "Global Active Power (kilowatts)")

dev.off()
##close png device