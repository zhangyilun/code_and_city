
# setwd
setwd("data_analysis/code_and_city/")

# load data
parking <- read.csv("data_geo/Parking_Tickets.csv",stringsAsFactors = F)
office1 <- read.csv("data_geo/2016_Office_Buildings.csv",stringsAsFactors = F)
office2 <- read.csv("data_geo/2016_Office_Centre_Shapes.csv",stringsAsFactors = F,row.names = NULL)
residence <- read.csv("data_geo/2016_Residential_Directory__Townhouse_Complexes.csv",stringsAsFactors = F)
secondUnit <- read.csv("data_geo/Licensed_Second_Units.csv",stringsAsFactors = F)
eat <- read.csv("data_geo/Licensed_Eateries.csv",stringsAsFactors = F)

# keep only lon and lat
parking <- parking[,c("lat","lon")]
office1 <- office1[,c("lat","lon")]
office2 <- office2[,c("lat","lon")]
residence <- residence[,c("lat","lon")]
secondUnit <- secondUnit[,c("lat","lon")]
eat <- eat[,c("lat","lon")]

colnames(parking) <- c("lon","lat")
office1$lon <- as.numeric(office1$lon)
office2$lon <- as.numeric(office2$lon)
residence$lon <- as.numeric(residence$lon)
residence$lat <- as.numeric(residence$lat)

# remove missing or wrong data
north <- 43.740733
south <- 43.477434
east <- -79.539981
west <- -79.813423

# filter for wrong lat & lon
parking <- parking[parking$lat >= south & parking$lat <= north & parking$lon >= west & parking$lon <= east,]
office1 <- office1[office1$lat >= south & office1$lat <= north & office1$lon >= west & office1$lon <= east,]
office2 <- office2[office2$lat >= south & office2$lat <= north & office2$lon >= west & office2$lon <= east,]
residence <- residence[residence$lat >= south & residence$lat <= north & residence$lon >= west & residence$lon <= east,]
secondUnit <- secondUnit[secondUnit$lat >= south & secondUnit$lat <= north & secondUnit$lon >= west & secondUnit$lon <= east,]
eat <- eat[eat$lat >= south & eat$lat <= north & eat$lon >= west & eat$lon <= east,]

# remove NA
parking <- parking[complete.cases(parking),]
office <- rbind(office1[complete.cases(office1),],office2[complete.cases(office2),])
residence <- rbind(residence[complete.cases(residence),],secondUnit[complete.cases(secondUnit),])
eat <- eat[complete.cases(eat),]

write.csv(parking,"data_geo/parking.csv",quote=F,row.names=F)
write.csv(office,"data_geo/office.csv",quote=F,row.names=F)
write.csv(residence,"data_geo/residence.csv",quote=F,row.names=F)
write.csv(eat,"data_geo/eat.csv",quote=F,row.names=F)
