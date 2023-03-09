#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA
from sklearn import preprocessing
from bioinfokit.visuz import cluster


# In[2]:


madelon = pd.read_csv("madelon.csv")

# Standardize data
standard = preprocessing.scale(madelon)

inertias = []

for i in (4,8,16,32,64):
    kmeans = KMeans(n_clusters=i,random_state=1, n_init="auto").fit(standard)
    inertias.append(kmeans.inertia_)

# Plot k-means cluster along inertia
plt.plot((4,8,16,32,64), inertias, marker='o')
plt.title('madelon')
plt.xlabel('Number of clusters')
plt.ylabel('Inertia(SSE)')
plt.show()

kmeans = KMeans(n_clusters=8,random_state=1,n_init = 'auto',init = 'random').fit(madelon)
kmeans.inertia_


# In[3]:


pca_madelon = PCA().fit(standard)
cum_sum_variance = np.cumsum(pca_madelon.explained_variance_ratio_)

plt.plot(range(1, len(cum_sum_variance)+1), cum_sum_variance)
plt.xlabel('number of components included')
plt.ylabel('the amount of variance captured')
plt.tight_layout()
plt.show()

component = np.interp(0.75,cum_sum_variance,range(1, len(cum_sum_variance)+1))
print(component)
## Based on the plot we got, 277 components are included equal or below the 75% 
## variance

# Selected Components
pca_madelon_tran_277 = PCA(n_components=277).fit_transform(standard)

plt.scatter(pca_madelon_tran_277[:,0],pca_madelon_tran_277[:,1])
plt.xlabel('PC1')
plt.ylabel('PC2')
plt.tight_layout()
plt.show()

pca_madelon_277 = PCA(n_components=277).fit(standard)

loadings = pca_madelon_277.components_[:2]
var1, var2 = np.abs(loadings).sum(axis=0).argsort()[-2:]


# Plot the original data on a scatter plot 
plt.scatter(standard[:, var1], standard[:, var2])
plt.xlabel('Var1')
plt.ylabel('Var2')
plt.show()

# Plot the K-means by the transformed data
inertias = []

for i in (4,8,16,32,64):
    kmeans = KMeans(n_clusters=i,random_state=1, n_init="auto").fit(pca_madelon_tran_277)
    inertias.append(kmeans.inertia_)

plt.plot((4,8,16,32,64), inertias, marker='o')
plt.title('standard')
plt.xlabel('Number of clusters')
plt.ylabel('Inertia(SSE)')
plt.show()

# create a scatter plot of PC 1 (x-axis) versus PC 2 (y-axis) for all of the transformed data points. Label the cluster centers and color-code by cluster assignment for the first 5 iterations of k = 32.
for i in range(5):
    kmeans = KMeans(n_clusters=32, n_init = 5, max_iter = i+1, random_state=1)
    preds = kmeans.fit_predict(standard)
    centers = kmeans.cluster_centers_
    
    plt.scatter(standard[:, 0], standard[:, 1], c=preds)
    
    for k in range(len(centers)):
        plt.scatter(centers[k][0], centers[k][1], s=100, marker='x', linewidths=3, color='r', label='Cluster Center')
   
    plt.xlabel('PC1')
    plt.ylabel('PC2')
    plt.show()

