################ HIERARCHICAL CLUSTERING ###################

########## AIRLINES DATAESET ##########

import pandas as pd
#pandas is used for data manipulation ,analysis and cleansing 
import numpy as np
#numpy is used for numerical calculations
import matplotlib.pyplot as plt
#it is used for data visualization purpose
airlines=pd.read_excel("D://360digiTMG/unsupervised/mod 12 Hierarchical Clustering/eastwest Airlines/EastWestAirlines.xlsx",sheet_name='data')

#normalization of the data converting to equvalent z values
def norm_func(i):
    x=(i-i.min())/(i.max()-i.min())
    return(x)


airlines.head()
df_norm=norm_func(airlines.iloc[:,1:])
df_norm.head()
from scipy.cluster.hierarchy import linkage
import scipy.cluster.hierarchy as sch
z=linkage(df_norm,method="complete",metric="euclidean")
plt.figure(figsize=(15,5));plt.title('hierarchical clustering dendrogram');plt.xlabel('index');plt.ylabel('distance')

sch.dendrogram(
        z,
        leaf_rotation=0,#rotates the x axis label
        leaf_font_size=8.#font size for x axis label 
)
plt.show()

#now applying Agglomerativeclusters and choosing clusters as 3 based on the dendrogram

from sklearn.cluster import AgglomerativeClustering
h_complete=AgglomerativeClustering(n_clusters=3,linkage="complete",affinity="euclidean").fit(df_norm)

clusters_lables=pd.Series(h_complete.labels_)
airlines['clust']=clusters_lables
airlines.head()
airlines=airlines.iloc[:,[12,0,1,2,3,4,5,6,7,8,9,10,11]]
airlines.head()

#getting aggregate mean of each clusters
so=airlines.iloc[:,2:].groupby(airlines.clust).mean
so
#create  a csv  file 
airlines.to_csv("D:/360digiTMG/unsupervised/mod 12 Hierarchical Clustering/eastwest Airlines/airlines_final_py.csv",encoding="utf-8")
import os
os.getcwd()


###########scree plot and elbow curve
from sklearn.cluster import KMeans
#K-means clustering is a clustering algorithm that aims to partition n observations into k clusters
from scipy.spatial.distance import cdist
#computes the distance b/w the points using euclidean distance

k=list(range(1,10))
k

TWSS=[]#variables for storing total withinsum of sqs for each k-means
for i in k:
    kmeans=KMeans(n_clusters = i)
    kmeans.fit(df_norm)
    WSS=[]#variables for storing with in sum of sqs for each clusters
    for j in range(i):
        WSS.append(sum(cdist(df_norm.iloc[kmeans.labels_==j,:],kmeans.cluster_centers_[j].reshape(1,df_norm.shape[1]),"euclidean")))
    TWSS.append(sum(WSS))
    
#scree plot
plt.plot(k,TWSS,'ro-');plt.xlabel("no of clusters");plt.ylabel("Tot Within SS");plt.xticks(k)

#selecting 3 clusters from the above scree plot which is the optimum no of clusters for a 12 variable dataset
model=KMeans(n_clusters=3)    
model.fit(df_norm)

model.labels_#getting the labels of the clusters assigned to each row
md=pd.Series(model.labels_)#converting  numpy array into pandas series of objects

airlines['clust']=md#creating a column and assigning it to new column
df_norm.head()

airlines.iloc[:,2:].groupby(airlines.clust).mean()


