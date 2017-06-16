total_type_Bal <- with(Baltimore_emissions, tapply(Emissions,list(type,year),sum))
total_type_Bal
temp <- as.vector(total_type_Bal)
temp_year <- rep(years,each=4)
temp_type <- rep(rownames(total_type_Bal ),times=4)
total_type_Bal <- data.frame(total.emissions = temp,year=temp_year,type=temp_type)

library(ggplot2)
ggplot(total_type_Bal,aes(y=total.emissions,x=year)) + geom_line() + facet_grid (type~.) + theme_bw()+ylab("Total Emissions") 
ggsave(file ='./figures/3 typeEmission_Bal.png')
