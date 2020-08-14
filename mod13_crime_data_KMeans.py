########## k means clustering ############

###crime data

import pandas as pd
#pandas is used for data manipulation,analysis,cleansing
import numpy as np
#numpy deals with numerical  data
import matplotlib.pylab as plt
#for data visualization
from sklearn.cluster import KMeans
from scipy.spatial.distance import cdist

#load dataset
crime=pd.read_csv("D:/360digiTMG/unsupervised/mod13_k means clustering/crime_data/crime_data.csv")
crime

def norm_func(i):
    x=(i-i.min())/(i.max()-i.min())
    return(x)

#normallize dataframe
df_norm=norm_func(crime.iloc[:,1:5])
df_norm.head()

#SCREW PLOT OR ELBOW PLOT
k=list(range(1,10))
k

TWSS=[]#variable for storing total within sum of squares for each kmeans
for i in k:
    kmeans=KMeans(n_clusters=i)
    kmeans.fit(df_norm)
    WSS=[]#variable for storing within sum of squares for each cluster
    for j in range(i):
        WSS.append(sum(cdist(df_norm.iloc[kmeans.labels_==j,:],kmeans.cluster_centers_[j].reshape(1,df_norm.shape[1]),"euclidean")))
    TWSS.append(sum(WSS))
    
plt.plot(k,TWSS,'ro-');plt.xlabel('no of clusters');plt.ylabel('total within SS');plt.xticks(k)

# Selecting 4 clusters from the above scree plot which is the optimum number of clusters 
model=KMeans(n_clusters=4)
model.fit(df_norm)

model.labels_# getting the labels of clusters assigned to each row 
md=pd.Series(model.labels_)# converting numpy array into pandas series object 
crime['clust']=md# creating a  new column and assigning it to new column 
df_norm.head()

crime=crime.iloc[:,[5,0,1,2,3,4]]

crime.iloc[:,1:6].groupby(crime.clust).mean()


