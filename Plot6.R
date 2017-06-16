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
print(changes_motor_LA_BA)
temp <- as.vector(changes_motor_LA_BA)
n <- nrow(changes_motor_LA_BA)
temp_year <- rep(years,each=n)
temp_city <- rep(rownames(changes_motor_LA_BA),times=n)
changes_motor_LA_BA <- data.frame(Changes.emissions = temp,year=temp_year,city=temp_city)

print("Emission Changes in %")
library(ggplot2)

ggplot(changes_motor_LA_BA,aes(y=Changes.emissions,x=year)) + geom_line() + facet_grid (city~.) + theme_bw() +ylab("Emissions Changes in %") 
ggsave(file ="./figures/6 MotorEmission_Bal_LA.png")
