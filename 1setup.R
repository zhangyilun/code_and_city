# library
library(ggmap)

# setwd
setwd("data_analysis/code_and_city/")

# load data
# for parking, already have location info for most of the frequent areas
# parking <- read.csv("data/Parking_Tickets.csv",stringsAsFactors = F)
office1 <- read.csv("data/2016_Office_Buildings.csv",stringsAsFactors = F)
office2 <- read.csv("data/2016_Office_Centre_Shapes.csv",stringsAsFactors = F)
residence <- read.csv("data/2016_Residential_Directory__Townhouse_Complexes.csv",stringsAsFactors = F)
secondUnit <- read.csv("data/Licensed_Second_Units.csv",stringsAsFactors = F)
eat <- read.csv("data/Licensed_Eateries.csv",stringsAsFactors = F)

# get geolocation, and save
office1_loc <- geocode(office1$StreetAddr)
office1 <- cbind(office1,office1_loc)
write.csv(office1, "data_geo/2016_Office_Buildings.csv", row.names = F, quote = F)

office2$loc1 <- sapply(office2$CentreLoca,function(s){strsplit(s,",")[[1]][1]})
office2_loc <- geocode(office2$loc1)
office2 <- cbind(office2,office2_loc)
write.csv(office2, "data_geo/2016_Office_Centre_Shapes.csv", row.names = F, quote = F)

residence$address <- paste(residence$Street.Number,residence$Street.Name,sep=" ")
residence_loc <- geocode(residence$address)
residence <- cbind(residence,residence_loc)
write.csv(residence, "data_geo/2016_Residential_Directory__Townhouse_Complexes.csv", row.names = F, quote = F)

secondUnit_loc <- geocode(secondUnit$PostalCode)
secondUnit <- cbind(secondUnit,secondUnit_loc)
write.csv(secondUnit, "data_geo/Licensed_Second_Units.csv", row.names = F, quote = F)  

eat_loc <- geocode(eat$POSTAL)
eat <- cbind(eat,eat_loc)
write.csv(eat, "data_geo/Licensed_Eateries.csv", row.names = F, quote = F)  

