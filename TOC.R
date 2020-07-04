##################################
#Total Operating Characteristiscs#
##################################

#Testing TOC for RF RGB data between 2 prediction mode 80/20
#TOC information: https://en.wikipedia.org/wiki/Total_operating_characteristic 

setwd("C:/Users/s1526/Dropbox/MB3_Scripts/Data/RF-QGIS")

library(TOC)
library(tidyverse)
library(rgdal)

list.files()

output_class_1.8020 <- raster(list.files()[4])
output_class_2.8020 <- raster(list.files()[5])
output_class_3.7525 <- raster(list.files()[6])

TOC_1_3 <- TOC(output_class_1.8020, output_class_3.7525)
TOC_2_3 <- TOC(output_class_2.8020, output_class_3.7525)

plot(TOC_1_3)
plot(TOC_2_3)
