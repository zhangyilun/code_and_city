# library
library(ggmap)

# data
parking <- read.csv("kmean/parking.csv")
office <- read.csv("kmean/office.csv")
residence <-read.csv("kmean/residence.csv")
eat <- read.csv("kmean/eat.csv")

# color
c = rgb(102/255,102/255,1,alpha=0.3) 

# kmean function
kmean <- function(data,n_centers,fname) {
    data <- data[,c("lon","lat")]
    plot(data$lat,data$lon,pch=16,col=c)
    means <- kmeans(data,n_centers)
    centers <- means$centers
    centers <- centers[,c("lon","lat")]
    plot(data, col = means$cluster,pch=16,main=fname)
    points(centers, col = 1:n_centers, pch = 8, cex= 5)
    # write.csv(centers,paste("kmean_result/",fname,".csv",sep=""),quote=F,row.names=F)
    return(centers)
}


# run
c_parking <- kmean(parking,4,"Parking")
c_office <- kmean(office,5,"Office")
c_residence <- kmean(residence,6,"Residence")
c_eat <- kmean(eat,6,"Eateries")


# boundary
north <- 43.740733
south <- 43.477434
east <- -79.539981
west <- -79.813423

# overlap centers
plot(c_parking,col="yellow",xlim=c(west,east),ylim=c(south,north),pch=16,cex=2)
points(c_office,col="blue",pch=16,cex=2)
points(c_residence,col="green",pch=16,cex=2)
points(c_eat,col="red",pch=16,cex=2)
legend("topright",pch=c(16,16), 
       col=c("yellow","blue","green","red"),
       c("parking","office","residence","eat"))

# join
all <- rbind(c_parking,c_office,c_residence,c_eat)
all <- data.frame(all)

# plot
m_map <- get_map(location = c(lat=43.595423, lon=-79.650824), zoom = 10)
ggmap(m_map, extent = "device") + 
    geom_point(aes(x = lon, y = lat), colour = "red", 
               alpha = 1, size = 3, data = all)


# plot heatmap
# get x,y,score by running Main.R
toUse <- data.frame(lon=NULL,lat=NULL,score=NULL)
for (i in 1:length(x)) {
    for (j in 1:length(y)) {
        toUse <- rbind(toUse,c(x[i],y[j],scores[i,j]))
    }
}
colnames(toUse) <- c("lon","lat","score")

# option 1
# not working
m_map <- get_map(location = c(lat=43.595423, lon=-79.650824), zoom = 10)
ggmap(m_map, extent = "device") + 
    geom_density2d(data = toUse, aes(x = lon, y = lat), size = 0.3) + 
    stat_density2d(data = toUse, aes(x = lon, y = lat), size = 0.01, geom = "polygon") + 
    scale_fill_gradient(low = "green", high = "red") +
    scale_alpha(range = c(0, 0.3), guide = FALSE)

# option 2
toUseHigh <- toUse[toUse$score >= 8,]
m_map <- get_map(location = c(lat=43.595423, lon=-79.650824), zoom = 11, color="bw")
ggmap(m_map,extent= "device") + 
    geom_point(data = toUseHigh, mapping = aes(lon, lat, colour=score), size=1, alpha=1, shape=15) + 
    geom_density2d(data = toUseHigh,mapping = aes(lon,lat,colour=score)) +
    scale_colour_gradient(low = 'green', high = 'red')
