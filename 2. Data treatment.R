
#cleaning Data

inatur <- read.csv("inaturalist.csv")  
# ==== Creating Dataframes ====================================================
taxa <- as.data.frame(inatur$iconic_taxon_name, stringsAsFactors=FALSE)
inatur <- as.data.frame(inatur, stringsAsFactors=FALSE)

#cleaning  iNaturalist data
#Remove all rows without taxa name from the data sets. 
cleaned.inatur <- inatur[!(is.na(inatur$iconic_taxon_name) | 
                             inatur$iconic_taxon_name ==""), ]
taxa <- inatur[!(is.na(taxa) | 
                   taxa ==""), ]

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


#mapping
library(maps)
library(mapdata)
map <- map("worldHires", "Canada", xlim=c(-141,-53), ylim=c(40,85), col="gray90"
           , fill=TRUE) 


library(maps)
library(mapdata)
library(maptools)  #for shapefiles
library(scales)  #for transparency

map("worldHires","Canada", xlim=c(-140,-110),ylim=c(48,64), col="gray90", fill=TRUE)
map <- map("worldHires","Canada", xlim=c(-140,-110),ylim=c(48,64), col="gray90", fill=TRUE)

#layer of data for species range
pcontorta <- sf::st_read("Building_Permits.shp")   #layer of data for species range
inatur <- read.csv("inaturalist.csv")

#my data for sampling sites, contains a column of "lat" and a column of "lon" 
#with GPS points in decimal degrees

map("worldHires","Canada", xlim=c(-140,-110),ylim=c(48,64), col="gray90", fill=TRUE)

#plot the region of Canada I want
map("worldHires","usa", xlim=c(-140,-110),ylim=c(48,64), col="gray95", fill=TRUE, add=TRUE)  


#add the adjacent parts of the US; can't forget my homeland
plot(pcontorta, add=TRUE, xlim=c(-140,-110),ylim=c(48,64), col=alpha("darkgreen", 0.6), border=FALSE) 
#plot the species range
points(samps$lon, samps$lat, pch=19, col="red", cex=0.5)  #plot my sample sites
Details to note from this process: when






#How many species are there in each iconic taxa
species_per_group <- cleaned.inatur$iconic_taxon_name
group_by(taxa)
