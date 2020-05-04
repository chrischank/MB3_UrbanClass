#######################
#EBBI Masking Würzburg#
#######################

library(RStoolbox)
library(tidyverse)
library(rgeos)
library(sp)
library(carets)
library(rgdal)
library(raster)
library(rasterVis)

setwd("C:/Users/s1526/Dropbox/MB3_Scripts/MB3_UrbanClass")

dir.create("C:/Users/s1526/Dropbox/MB3_Scripts/Data/Masked_EBBI", showWarnings = TRUE)

Data_path <- "C:/Users/s1526/Dropbox/MB3_Scripts/Data"
list.files(Data_path)


