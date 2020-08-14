############## K MEANS CLUSTERING ########################

########### CRIME DATAESET################

install.packages("plyr")
library(plyr)
#plyr package is used for manipulation

install.packages("animation")
library(animation)
?animation
#it is used for the visualization purpose

install.packages("kselection")
library(kselection)
?kselection
#kselection is used in selection of k value in kmeans 

crime <- read.csv(file.choose())
View(crime)

#access only numerical data
crime1 <- crime[-1]
View(crime1)

#standardize vaalues
norm_data <- scale(crime1)
View(norm_data)

d <- dist(norm_data,method = "euclidean")

k <- kselection(crime1,parallel = TRUE,k_threshold = 0.9)
k
#f(k) finds 2 clusters

install.packages("doParallel")
library(doParallel)
?doParallel
#it will provide parallel backend for the  foreach /%dopar% functions

registerDoParallel(cores = 4)
k <- kselection(crime1,parallel = TRUE,k_threshold = 0.9,max_centers = 5)
k
#f(k) finds 2 clusters

fit <- kmeans(norm_data,4)
fit
str(fit)

final2<- data.frame(crime1, fit$cluster) # append cluster membership
final2
final3 <- final2[,c(ncol(final2),1:(ncol(final2)-1))]
aggregate(crime1, by=list(fit$cluster), FUN=mean)

#using elbow curve & k~sqrt(n/2)=>k 
  
wss = (nrow(norm_data)-1)*sum(apply(norm_data, 2, var))		 # Determine number of clusters by scree-plot 
for (i in 1:8) wss[i] = sum(kmeans(norm_data, centers=i)$withinss)
plot(1:8, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares")   # Look for an "elbow" in the scree plot #
title(sub = "K-Means Clustering Scree-Plot")

#by looking at scree plot i wil k value as 4

km <- kmeans(norm_data,2)
str(km)
km
#Within cluster sum of squares by cluster:
#[1] 56.11445 46.74796
#(between_SS / total_SS =  47.5 %)

km3 <- kmeans(norm_data,3)
km3
#Within cluster sum of squares by cluster:
#[1] 19.922437  8.316061 53.354791
#(between_SS / total_SS =  58.4 %)

km4 <- kmeans(norm_data,4)
km4
#Within cluster sum of squares by cluster:
#[1]  8.316061 11.952463 16.212213 19.922437
#(between_SS / total_SS =  71.2 %)

# taking 4 clusters will be good 

str(km4)
km4$size
#8 13 16 13


km4.res <- kmeans(norm_data, 4, nstart = 25)
print(km4.res)

aggregate(crime1, by=list(cluster=km4.res$cluster), mean)

#partition aroun mediods
install.packages("cluster")
library(cluster)
xpm <- pam(norm_data,4)
clusplot(xpm)
