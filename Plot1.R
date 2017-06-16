download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",destfile="Data.zip")
unzip("Data.zip",exdir = "./Data")
Source_db <- readRDS("./Data/Source_Classification_Code.rds")
emissions <- readRDS("./Data/summarySCC_PM25.rds")
years <- unique(emissions$year)
total_y <- tapply(emissions$Emissions,emissions$year,sum)
plot(total_y,type="l",xaxt ="n",xlab = "Year",ylab="Total Emissions",main = 
             "Total Emissions in the U.S")
axis(side=1,labels=as.character(years),at=1:length(years))
png(filename ='./figures/1 totalemission.png')
plot(total_y,type="l",xaxt ="n",xlab = "Year",ylab="Total Emissions",main = 
             "Total Emissions in the U.S")
axis(side=1,labels=as.character(years),at=1:length(years))
dev.off()
