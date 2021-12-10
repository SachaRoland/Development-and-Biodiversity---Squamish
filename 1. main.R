
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
setwd("~/Desktop/R/Final Project")
wk.di <- getwd()


#=======Import raw data sets from iNaturalist ==================================
inatur <- read.csv("inaturalist.csv")   
#data quick check
head(inatur)
str(inatur)

build.perm <- read.csv("Building_Permits.csv")
str(build.perm)

# ==== Creating Dataframes ====================================================
taxa <- as.data.frame(inatur$iconic_taxon_name, stringsAsFactors=FALSE)
inatur <- as.data.frame(inatur, stringsAsFactors=FALSE)

#cleaning  iNaturalist data
#Remove all rows without taxa name from the data sets. 
cleaned.inatur <- inatur[!(is.na(inatur$iconic_taxon_name) | 
                             inatur$iconic_taxon_name ==""), ]
str(cleaned.inatur)


#get of rid of all non-necessary columns???


#Specify columns of interest
cols(
  observed_on = col_character(),
  latitude = col_character(),
  longitude = col_character(),
  scientific_name = col_character(),
  common_name = col_character(),
  iconic_taxon_name = col_character(),
  taxon_id = col_character(),
)

head(cleaned.inatur)

#how many unique value is there is column
sapply(cleaned.inatur, function(x) length(unique(x)))
# 4192 unique taxon Id observed in the Squamish area. 

#Determine how many unique species in each iconic taxonomic group. 
spp_per_group <-cleaned.inatur%>%
  group_by(iconic_taxon_name) %>%
  summarise(species = n())
print(spp_per_group)
