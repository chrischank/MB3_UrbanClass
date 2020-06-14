library(raster)
library(RStoolbox)
library(rgdal)
library(e1071)
library(randomForest)
library(tidyverse)
library(raster)
library(rasterVis)

setwd("C:/Users/s1526/Dropbox/MB3_Scripts/Data/RF-QGIS")

allband <- raster("C:/Users/s1526/Dropbox/MB3_Scripts/Data/Wü_RGB.tif")

td <- readOGR("C:/Users/s1526/Dropbox/MB3_Scripts/Data/Training")

plot(allband[[1]])
plot(td,add=TRUE)

sc2<-superClass(allband,trainData=td,
               responseCol = "Class_id",
               model = "rf", 
               tuneLength = "random",
               trainPartition = 0.75,
               filename="Class_test2.tif"  
               )

plot(sc2$map)

sc2$validation$performance

output_class_3 <- raster::predict(allband, sc2$model, filename="output_class_3", format="GTiff", overwrite=TRUE)

plot(output_class_3)
