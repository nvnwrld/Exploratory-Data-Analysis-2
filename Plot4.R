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
