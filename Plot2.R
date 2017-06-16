Baltimore_emissions <- emissions[emissions$fips=="24510",]
total_Baltimore_y <- tapply(Baltimore_emissions$Emissions,Baltimore_emissions$year,sum)
total_Baltimore_y
png(filename ='./figures/2 BaltimoreEmission.png')
plot(total_Baltimore_y,type="l",xaxt ="n",xlab = "Year",ylab="Total Emissions",main = "Total Emissions in the Baltimore")
axis(side=1,labels=as.character(years),at=1:length(years))
dev.off()
