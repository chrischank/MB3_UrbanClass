library(raster)
library(RStoolbox)
library(rgdal)
install.packages("e1071")
library(e1071)
library(randomForest)
setwd("C:/Users/chofi/Documents/2019/Maestria/FieldMeasurements/Class")
allband<-raster("C:/Users/chofi/Dropbox/MB3_Scripts/Data/Wü_RGB.tif")
td<-readOGR("shapes_class/trainpoly_merged.shp")

plot(allband[[1]])
plot(td,add=TRUE)

sc2<-superClass(allband,trainData=td,
               responseCol = "Class_id",
               model = "rf", 
               tuneLength = 1,
               trainPartition = 0.70,
               filename="Class_test2.tif"  
               )
plot(sc2$map)
sc2$validation$performance

