##########################
#Index Creation Wuerzburg#
#        04/05/2020      #
#Author: Chris Chan      #
##########################

library(RStoolbox)
library(tidyverse)
library(rgeos)
library(sp)
library(caret)
library(rgdal)
library(raster)
library(rasterVis)
library(viridis)
library(cluster)

setwd("C:/Users/s1526/Dropbox/MB3_Scripts")
dir.create("C:/Users/s1526/Dropbox/MB3_Scripts/indices")

Data_path <- "C:/Users/s1526/Dropbox/MB3_Scripts/Data"
list.files(Data_path)

#LOAD ROI shapefile
Würzburg_ROI <- readOGR(Data_path, "Wue_MB3_extent", verbose = TRUE, encoding="ESRI Shapefile")
proj4string(Würzburg_ROI) <- CRS("+init=epsg:32632")
summary(Würzburg_ROI)
plot(Würzburg_ROI)

#LOAD bands for IBI and RGB
setwd(Data_path)
list.files()

b11_MIR <- raster(list.files()[1])
b8_NIR <- raster(list.files()[5])
b4_RED <- raster(list.files()[4])
b3_GREEN <- raster(list.files()[3])
b2_BLUE <- raster(list.files()[2])

#Create RGB stack
Wü_RGB <- stack(b4_RED, b3_GREEN, b2_BLUE)
ggRGB(Wü_RGB, r=1, g=2, b=3, stretch="hist")
writeRaster(Wü_RGB, "Wü_RGB.tif", format="GTiff", overwrite=TRUE)

#################
#INDEX FUNCTIONS#
#################
#One for vegetation, one for built-up, one for water

#IBI----
#band 

IBI <- function(MIR, NIR, GREEN, RED){
  ibi <- ((2*MIR)/(MIR+NIR)-(NIR/(NIR+RED)+GREEN/(GREEN+MIR)))/
    ((2*MIR/(MIR+NIR))+(NIR/(NIR+RED)+GREEN/(GREEN+MIR)))
  return(ibi)
}

#NDVI----
#band 8, band 4

#NDVI <- function(NIR, RED){
#  ndvi <- (NIR-RED)/
#    (NIR+RED)
#  return(ndvi)
#}

#NDWI----
#NDWI <- function(GREEN, NIR){
#  ndwi <- (GREEN-NIR)/
#    (GREEN+NIR)
#  return(ndwi)
#}

#Disaggregate b11 from 20m res to 10m fact=2 res for calculation
DissAgg.b11_MIR <- disaggregate(b11_MIR, fact=2)

all_band <- stack(b2_BLUE, b3_GREEN, b4_RED, b8_NIR, DissAgg.b11_MIR)

Wü_IBI <- IBI(DissAgg.b11_MIR, b8_NIR, b3_GREEN, b4_RED)
plot(Wü_IBI)

Wü_NDVI <- spectralIndices(all_band, blue=1, green=2, red=3, nir=4, swir2=5, scaleFactor = 1, index="NDVI")
plot(Wü_NDVI)

Wü_NDWI <- spectralIndices(all_band, blue=1, green=2, red=3, nir=4, swir2=5, scaleFactor = 1, index="NDWI")
plot(Wü_NDWI)

#Mask ROI of IBI
setwd("C:/Users/s1526/Dropbox/MB3_Scripts/Indices")
Mask_Wü_IBI <- mask(Wü_IBI, Würzburg_ROI)
Mask_Wü_RGB <- mask(Wü_RGB, Würzburg_ROI)
Mask_Wü_NDVI <- mask(Wü_NDVI, Würzburg_ROI)
Mask_Wü_NDWI <- mask(Wü_NDWI, Würzburg_ROI)
ggR(Mask_Wü_IBI)
ggR(Mask_Wü_NDVI)
ggR(Mask_Wü_NDWI)
ggRGB(Mask_Wü_RGB, r=1, g=2, b=3, stretch="hist")
writeRaster(Mask_Wü_IBI, "Wü_ROI_IBI.tif", format="GTiff", overwrite=TRUE)
writeRaster(Mask_Wü_NDVI, "Wü_ROI_NDVI.tif", format="GTiff", overwrite=TRUE)
writeRaster(Mask_Wü_NDWI, "Wü_ROI_NDWI.tif", format="GTiff", overwrite=TRUE)

#Condition if > 0.013 = Built-up
#Builtup_ROI_IBI <- reclassify(Mask_Wü_IBI, cbind(-Inf, -0.1, NA))
#writeRaster(Builtup_ROI_IBI, "Data/Masked_IBI/Builtup_ROI_IBI.tif", format="GTiff", overwrite=TRUE)

stack_ROI_indices <- stack(Mask_Wü_IBI, Mask_Wü_NDVI, Mask_Wü_NDWI)
writeRaster(stack_ROI_indices, "stack_ROI_indices.tif", format="GTiff", overwrite=TRUE)
writeRaster(stack_ROI_indices, "stack_ROI_indices.grd", format="raster", overwrite=TRUE)
