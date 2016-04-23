
# The corners of missisauga
top <- c(43.740733, -79.637284)
left <- c(43.590197, -79.813423)
right <- c(43.576821, -79.539981)
bot <- c(43.477434, -79.625210)

airport <- c(-79.623806, 43.675777)
square.one <- c(-79.642984, 43.592654)
kipling <- c(-79.536204, 43.636882)

# x and y labels
x <- seq(-79.813423, -79.539981 + 0.1, 0.005)
y <- seq(43.477434 - 0.02, 43.740733 + 0.02, 0.005)

# locs stores the latitude and longitude info of each location
#locs <- array(dim=c(length(x), length(y), 2, 2))

f <- Vectorize(function(x,y){
  return(0)
})

# scores stores the clustered scores of each location
scores <- outer(x, y, f)

dist <- function(a,b){
  d <- sqrt(sum((a - b)^2))
  return(d)
}

calc.score <- function(p, centre, max.score, lambda){
  d <- dist(centre, p)
  score <- max.score*exp(-d*lambda)
  return(score)
}

update <- function(mat, p, val){
  
  x.ind <- which.min(abs(x - p[1]))
  y.ind <- which.min(abs(y - p[2]))
  
  centre <- c(x[x.ind], y[y.ind])
  
  spread <- 50
 
  inc <<- matrix(0, length(x), length(y))
  for(i in 1:length(x)){
    for(j in 1:length(y)){
      inc[i,j] <<- calc.score(c(x[i], y[j]), centre, val, spread)
    }
  }
  
  #print(inc)
  
  mat = mat + inc
  
  return(mat)
}

office.centers <- as.matrix(read.csv('kmean_result/office.csv', header=F, sep=',', skip=1))
eat.centers <- as.matrix(read.csv('kmean_result/eat.csv', header=F, sep=',', skip=1))
parking.centers <- as.matrix(read.csv('kmean_result/parking.csv', header=F, sep=',', skip=1))
housing.centers <- as.matrix(read.csv('kmean_result/residence.csv', header=F, sep=',', skip=1))


# print(scores)
# scores <- update(scores, office.centers[1,], 5)

for(i in 1:nrow(office.centers)){
 scores <- update(scores, office.centers[i,], 8)
}
for(i in 1:nrow(eat.centers)){
  scores <- update(scores, eat.centers[i,], 3)
}
for(i in 1:nrow(parking.centers)){
  scores <- update(scores, parking.centers[i,], 2)
}
for(i in 1:nrow(housing.centers)){
  scores <- update(scores, housing.centers[i,], 5)
}
filled.contour(x,y,scores, nlevels = 30)
title('Mississauga')
points(kipling[1], kipling[2], pch=16, col=2)
points(square.one[1], square.one[2], pch=16, col=1)
points(airport[1], airport[2], pch=16, col=4)

legend("topleft",col=c(2,1,4),c("Airport","Square One","Kipling"),pch=c(16,16,16))

#contour(x,y,z)
#heatmap(z)
#points(top)
segments(top[2],top[1], left[2], left[1])
segments(bot[2],bot[1], left[2], left[1])
segments(top[2],top[1], right[2], right[1])
segments(bot[2],bot[1], right[2], right[1])
