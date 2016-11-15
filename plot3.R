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

##convert column dt to date
edata<-transform(edata, dt =as.POSIXlt(strptime(dt,"%d/%m/%Y %H:%M:%S")))

##open png device
png(file="plot3.png")

##plot Third graph
##plot Sub_metering_1
with(edata,plot(dt,Sub_metering_1,type="n",ylab="Energy sub metering", xlab="datetime"))

with(edata,lines(dt,Sub_metering_1))

##plot Sub_metering_2

with(edata,lines(dt,Sub_metering_2,col="red"))

##plot Sub_metering_3

with(edata,lines(dt,Sub_metering_3,col="blue"))

##add legend
legend("topright",lwd=1,lty=1,col=c("black","red","blue"),
       legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

dev.off()
##close png device