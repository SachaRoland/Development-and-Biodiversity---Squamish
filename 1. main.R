
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


#===== Packages and libraries =====================================
#install.packages("sf")
#install.packages("maps")
#install.packages("tmap")
#install.packages("ggmap")
#install.packages("mapdata")
#install.packages(rinat)
#install.packages(dplyr)
#install.packages(leaflet)
#install.packages(conflicted)
#install.packages(ggplot2)

library(rinat)
library(sf)
library(dplyr)
library(tmap)
library(leaflet)
library(conflicted)
library(ggplot2)

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
wk.di <- getwd()

# === folder management ========================================================

## names of project folders("a.spatial data treatment","b.mapping","c.analyis")
## store names of the folders in an object

# folder names
## the a b c makes them ordered again, but not 
folder.names <- c("a.spatial data treatment","b.mapping")

# create folders if they don't exit yet. 
for(i in 1:length(folder.names)){ 
  if(file.exists(folder.names[i]) == FALSE){
    dir.create(folder.names[i])
  } 
}


# ******************************************************************************

# paths to the folders. The 'p.' indicates the variable is a path.
# make sure the variable names describe the folder.names
p.data.raw <- paste(wk.dir, "/", folder.names[1], "/", sep = "")
p.fig <- paste(wk.dir, "/", folder.names[2], "/", sep = "")

# === run script ===============================================================

## you can run a scripts file as a batch the start. Only do this for code which  
## is really needed to run other script files. Take care not to force the user
## to run the whole project at once especially when computationally intensive

# run scripts needed to make other scripts files work (e.g. functions.R)
#source("your.code.R")

#___ end _______________________________________________________________________
