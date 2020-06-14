#############
#ELSA & GLCM#
#13/06/2020 #
#############

#GLCM----

#The problem with GLCM is a lot of them based on tonal, maybe only ENT apply

library(tidyverse)
library(RStoolbox)
library(raster)
library(rgdal)
library(glcm)
library(elsa)

setwd("C:/Users/s1526/Dropbox/MB3_Scripts/indices/Kmeans")

kmeans <- raster(list.files()[10])

plot(kmeans)

unique(values(kmeans))

kmeans[kmeans == 4] <- NA

plot(kmeans)

writeRaster(kmeans, "Kmeans_result.tif", "GTiff", overwrite=TRUE)

kmeans_glcm <- glcm(kmeans)

plot(kmeans_glcm)

writeRaster(kmeans_glcm, "Kmeans_GLCM.tif", "GTiff", overwrite=TRUE, bylayer = TRUE)

#ELSA----

#ELSA works with categorical spatial data

kmeans_elsa <- elsa(kmeans)

plot(kmeans_elsa)
