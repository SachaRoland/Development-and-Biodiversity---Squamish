
#========General================================================================
# Project by Sacha 
#R version
# "R version 4.1.2 (2021-11-01)"

#=============Script index======================================================
# 1.Main.R        
# 2.Data.manipulation.R
# 3.Data analysis.R
# 4.Figures.R

# === global variables =========================================================
# declare variables that will be used across the project and should not be 
# changed. For example names, or a range of e.g. dates selected, etc. 

# read both csv's to define DEFAULT variables
# comment these out after first use, or if other values are desired


#=====Install packages required for mapping=====================================
install.packages("sp") 
install.packages("sf")
install.packages("maptools")
install.packages("rgeos")
install.packages("rgdal")
install.packages("raster")
install.packages("RCurl")
install.packages("USAboundaries")
install.packages("jsonlite")
install.packages("geojsonio")
install.packages("maps")
install.packages("tmap")
install.packages("micromap")
install.packages("ggrepel")
install.packages("ggmap")
install.packages("mapview")
install.packages("plotly")
install.packages("tidyverse")
install.packages("mapdata")

#======== Open Libraries fro mapping ===========================================
library(maptools)
library(sf)
library(rgeos)
library(rgdal)
library(raster)
library(RCurl)
library(USAboundaries)
library(jsonlite)
library(geojsonio)
library(maps)
library(tmap)
library(micromap)
library(ggrepel)
library(ggmap)
library(mapview)
library(sf)
library(ggplot2)
library(plotly)
library(tidyverse)
library(mapdata)


-------------------------------------------------------------------------------
getwd()

#=======Import raw data sets from iNaturalist ==================================
inatur <- read.csv("inaturalist.csv")   
#data quick check
head(inatur)
str(inatur)

build.perm <- read.csv("Building_Permits.csv")
str(build.perm)

busin.lic <- read.csv("Business_Licence_Monthly.csv")

# ==== Creating Dataframes ====================================================
taxa <- as.data.frame(inatur$iconic_taxon_name, stringsAsFactors=FALSE)
inatur <- as.data.frame(inatur, stringsAsFactors=FALSE)

#cleaning  iNaturalist data
#Remove all rows without taxa name from the data sets. 
cleaned.inatur <- inatur[!(is.na(inatur$iconic_taxon_name) | 
                             inatur$iconic_taxon_name ==""), ]
taxa <- inatur[!(is.na(taxa) | 
                             taxa ==""), ]
cleaned.inatur[253, "V"]


#organizing data frame by date. 
cleaned.inatur[order(as.Date(cleaned.inatur$iconic_taxon_name, format="%Y-%m-%d")),]

time <- cleaned.inatur[order(as.Date(cleaned.inatur$iconic_taxon_name, format="%Y-%m-%d")),]

?as.Date

#Time frame for building permits 
starting.year <- "2019/01/01 00:00:00+00"
ending.year <- "2021/12/31 00:00:00+00"

#organising data frame by date. 
cleaned.taax [order(as.Date(d$V3, format="%d/%m/%Y")),]


longitude <- 
latitude <- inat



# ====== Testing some Figures =================================================

#mapping tool
build.perm.map <- sf::st_read("Building_Permits.shp")
build.perm.map <- st_read("Building_Permits.shp")
str(build.perm.map)

#get spatial spread of building permits. 
coordinate.map <- ggplot(build.perm.map) + geom_sf()
str(coordinate.map)


#plot all variables = 19 
plot <- plot(build.perm.map, max.plot = 19)
str(plot)

plot(build.perm.map$geometry) # Why do I not have the boundary of the map? 

#problems with spatial points Need to find actual map
tm_shape(build.perm.map) + tm_polygons(build.perm.map$geometry)

#Need a map of Squamish divided into polygons WHHERE?
#Convert list to numeric values. 
build.perm.map <- as.numeric(unlist(build.perm.map))
polygon(build.perm.map)

show.poly <- polygon(build.perm.map)




#plot types of building type  --> fix. GOOD SHIT. 
hist(build.perm.map$Applicatio, breaks = 6)
