####################### HEIRARCHICAL CLUSTERING ##############################

############airlines dataset############

install.packages("plyr")
library(plyr)
#plyr is used to manipulate data 

install.packages("animation")
library(animation)
#to create and export animations to a variety of formats and and it also serves as a gallery of statistical animations.

install.packages("kselection")
library(kselection)

install.packages("doParallel")
library(doParallel)
#Provides a parallel backend for the %dopar% function

install.packages("cluster")
library(cluster)
library(readxl)

####Read the xls sheet =2
mydata <- read_xlsx("D:\\360digiTMG\\unsupervised\\mod 12 Hierarchical Clustering\\eastwest Airlines\\EastWestAirlines.xlsx",sheet=2)
View(mydata)
attach(mydata)
nor_data <- scale(mydata[,2:12])
View(nor_data)

d <- dist(nor_data,method = "euclidean")
fit <- hclust(d,method = "complete")

#dendrogram
plot(fit,hang = -1)
groups <- cutree(fit,k=3)
rect.hclust(fit,k=3,border = "red")

membership <- as.matrix(groups)

final <- data.frame(mydata,membership)
final_airlines <- final[,c(ncol(final),1:(ncol(final)-1))]

write.csv(final_air,file="final_airlines.csv")
getwd()

################################ k selection #####################################################
install.packages("kselection")
library(kselection)

View(mydata)
k <- kselection(mydata[,-1],parallel=TRUE,k_threshold=0.9,max_centers = 12)
k

#elbow plot
wss=(nrow(nor_data)-1)*sum(apply(nor_data,2,var))#determine no of clusters based on scree plot
for (i in 1:8) wss[i]=sum(kmeans(nor_data,centers=i)$withinss)
plot(1:8,wss,type="b",xlab = "number of clusters",ylab = "within groups sum of squares")  #look for an elbow in the screeplot
title(sub="kmeans clustering scree plot" )
#based on the scree plot taking k=3

km <- kmeans(nor_data,3)
str(km)

#For a good model tot.withinss should be more and betweenss should be less

km$centers
km$size
#[1] 1285  192 2522 #no of clusters and the data fall in the that cluster

#km <- kmeans(nor_data,4)
#str(km)

#km <- kmeans(nor_data,5)
#str(km)


################## k clustering alternative for large dataset - Clustering Large Applications (Clara)
install.packages("cluster")
library(cluster)
xcl <- clara(nor_data,3,samples = 100)
clusplot(xcl)
