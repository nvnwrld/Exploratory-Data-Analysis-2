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
Baltimore_emissions <- emissions[emissions$fips=="24510",]
total_Baltimore_y <- tapply(Baltimore_emissions$Emissions,Baltimore_emissions$year,sum)
png(filename ='./figures/2 BaltimoreEmission.png')
plot(total_Baltimore_y,type="l",xaxt ="n",xlab = "Year",ylab="Total Emissions",main = "Total Emissions in the Baltimore")
axis(side=1,labels=as.character(years),at=1:length(years))
dev.off()
total_type_Bal <- with(Baltimore_emissions, tapply(Emissions,list(type,year),sum))
temp <- as.vector(total_type_Bal)
temp_year <- rep(years,each=4)
temp_type <- rep(rownames(total_type_Bal ),times=4)
total_type_Bal <- data.frame(total.emissions = temp,year=temp_year,type=temp_type)

library(ggplot2)
ggplot(total_type_Bal,aes(y=total.emissions,x=year)) + geom_line() + facet_grid (type~.) + theme_bw()+ylab("Total Emissions") 
ggsave(file ='./figures/3 typeEmission_Bal.png')

#search for coal related SCC
index <- which( grepl("coal",Source_db[,"Short.Name"]) ) 
index2 <- which( grepl("Coal",Source_db[,"Short.Name"]) ) 
allindex <- unique (sort (c(index,index2)))
Source_db_coal <- Source_db[allindex,]
#get data subset for coal, caculate total emission
emissions_coal <- emissions[which(emissions$SCC %in% Source_db_coal$SCC),]
total_coal <- tapply(emissions_coal$Emissions,emissions_coal$year,sum)
#plotting the trend
png(filename = './figures/4 CoalEmission.png')
plot(total_coal,type="l",xaxt ="n",xlab = "Year",ylab="Total Emissions",main = "Total Emissions from coal combustion-related sources")
axis(side=1,labels=as.character(years),at=1:length(years))
dev.off()
#search for motor related SCC
index <- which( grepl("Highway Veh",Source_db[,"Short.Name"]) ) 
Source_db_motor <- Source_db[index,]
#get data subset for motor, caculate total emission
Bal_emissions_motor <- Baltimore_emissions[which(Baltimore_emissions$SCC %in% Source_db_motor$SCC),]
total_motor_Bal <- tapply(Bal_emissions_motor$Emissions,Bal_emissions_motor$year,sum)
#plotting the trend
png('./figures/5 MotorEmission_Bal.png')
plot(total_motor_Bal,type="l",xaxt ="n",xlab = "Year",ylab="Total Emissions",main = "Total Emissions from motor vehicle in Baltimore City")
axis(side=1,labels=as.character(years),at=1:length(years))

dev.off()
#search for motor related SCC
index <- which( grepl("Highway Veh",Source_db[,"Short.Name"]) ) 
Source_db_motor <- Source_db[index,]


#get motor emmisions data for Baltimore and Los Angeles (fips == "06037")

LA_BA_emissions <- emissions[emissions$fips=="06037"|emissions$fips=="24510",]
LA_BA_emissions_motor <- LA_BA_emissions[which(LA_BA_emissions$SCC %in% Source_db_motor$SCC),]
total_motor_LA_BA <- with(LA_BA_emissions_motor, tapply(Emissions,list(fips,year),sum))

rownames(total_motor_LA_BA)[which(rownames(total_motor_LA_BA)=="06037")] <- "Los Angeles"
rownames(total_motor_LA_BA)[which(rownames(total_motor_LA_BA)=="24510")] <- "Baltimore"

changes_motor_LA_BA <- matrix(NA, nrow=nrow(total_motor_LA_BA),ncol=ncol(total_motor_LA_BA))
colnames(changes_motor_LA_BA) <- colnames(total_motor_LA_BA)
rownames(changes_motor_LA_BA) <- rownames(total_motor_LA_BA)

changes_motor_LA_BA[1,] <- log10(total_motor_LA_BA[1,]/total_motor_LA_BA[1,1])*100
changes_motor_LA_BA[2,] <- log10(total_motor_LA_BA[2,]/total_motor_LA_BA[2,1])*100
print("Emission Changes in %")
temp <- as.vector(changes_motor_LA_BA)
n <- nrow(changes_motor_LA_BA)
temp_year <- rep(years,each=n)
temp_city <- rep(rownames(changes_motor_LA_BA),times=n)
changes_motor_LA_BA <- data.frame(Changes.emissions = temp,year=temp_year,city=temp_city)

print("Emission Changes in %")
library(ggplot2)

ggplot(changes_motor_LA_BA,aes(y=Changes.emissions,x=year)) + geom_line() + facet_grid (city~.) + theme_bw() +ylab("Emissions Changes in %") 
ggsave(file ="./figures/6 MotorEmission_Bal_LA.png")
