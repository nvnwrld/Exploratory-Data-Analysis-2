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
