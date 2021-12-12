
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
-------------------------------------------------------------------------------
setwd("~/Desktop/R/Fresh")
wk.di <- getwd()

--------------------
#Determine bounds based on the Squamish district coordinates 
bounds <- c(49.680314, -123.219144, 49.824274, -123.081815)


#Get Inaturalist data for different taxon in Squamish in 2020 using rinat package
plants <- get_inat_obs (taxon_name = "Plantae", bounds = bounds, year = 2020)
amphibians <- get_inat_obs (taxon_name = "Amphibia", bounds = bounds, year = 2020)
birds <- get_inat_obs (taxon_name = "Aves", bounds = bounds, year = 2020)
fungi <- get_inat_obs (taxon_name = "Fungi", bounds = bounds, year = 2020)
insects <- get_inat_obs (taxon_name = "Insecta", bounds = bounds, year = 2020)
arachnids <- get_inat_obs (taxon_name = "Arachnida", bounds = bounds, year = 2020)
reptiles <-get_inat_obs (taxon_name = "Reptilia", bounds = bounds, year = 2020)
mammals <- get_inat_obs (taxon_name = "Mammalia", bounds = bounds, year = 2020)
fish <- get_inat_obs (taxon_name = "Actinopterygii", bounds = bounds, year = 2020)
molluscs <- get_inat_obs (taxon_name = "Mollusca", bounds = bounds, year = 2020)


#determine crs for fo date sets. 
st_crs()

#convert data in spartial data. 
#convert into shapefile. 
molluscs_sf <- molluscs %>% 
  select(longitude, latitude, datetime, common_name, 
         scientific_name ) %>% 
  st_as_sf(coords=c("longitude", "latitude"), crs=4326) # crs found 

============================ Get Squamish boundary from Zoning.shp =======================
#read shp file.
squam.boundary <- st_read("Zoning_Classification.shp")
names(squam.boundary)

#Determine projected CRS --> NAD83 / UTM zone 10N
dplyr::filter(squam.boundary)
squam.boundary$Type
str(squam.boundary$Type)

#how many zone types is there is Squamish?
sapply(squam.boundary, function(x) length(unique(x)))

# have a look at all the zone types
zone.type <- squam.boundary%>%
  group_by(Type) %>%
  summarise(type = n())
print(zone.type)


# Check crs format of shp file and and create an object. 
NAD83CRS <- st_crs(squam.boundary)

#Plot zones in Squamish + legends. 
plot(squam.boundary[5])

# for inaturalist and Squamish boundary data to be compatible, they need need to hae the same crs. 
#convert squamish boudnary crs to WGS84 using package raster
      
r <- raster(squam.boundary)
#set up an output
x <- raster(r)
crs(x) <- "+proj=utm +zone=12 +datum=WGS84 +no_defs +ellps=WGS84"

squam.boundaryWGS84 <- projectRaster(r, x)

       
       
       
       
#transform boundary into geographic coordinates
squam.boundary.trans <- st_read("Zoning_Classification.shp", quiet=TRUE) %>%
  st_transform()  #needs WGS84




