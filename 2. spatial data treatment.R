#Description

Coming soon...

#======================= 1)Read raw data ============================================

#Read and transform the Squamish Zones Boundary to spatial coordinates.               
squamish.boundary.sf <- sf::st_read("Zoning_Classification.shp")
   
#Read and transform the Squamish Zones Boundary to spatial coordinates   
build.perm.sf<- sf::st_read("Building_Permits.shp")                 

========================2) Apply Squamish boundary on a map ============================

#First we need to transform the Squamsih boundary to geopgraphic coordinates.
squamish.boundary.sf <- st_read("Zoning_Classification.shp", quiet=TRUE) %>%
                                st_transform(4326) #EPS code for spatial data format

# Use leaflet to map the boundaries 
leaflet(squamish.boundary.sf[5])%>%   #[5] gives us option to determine different zone types
  addTiles() %>% 
  addPolygons(weight = 1) 
  
# Determine the geographic boundaries (coordinates) of the Squamish district. 
squamish.boundary.bb <- st_bbox(squamish.boundary.sf)

# Create object with bounds
bounds <- c(49.63866, -123.26034, 49.87288, -123.01753) --> use a general variables, put in main.

================== 3)Extract data from iNaturalist ==============================================

# Get data from specific taxa in Squamihs the Squamish area using rinat package. 
# use object bound to define the spread of results. 
# In this case I only collect data amphibians. Teh same process could eb for all taxa and specific species. 

amphibians <-get_inat_obs (taxon_name = "Amphibia", bounds = bounds, year = 2021, 
                         maxresults = 1000)
                         
# Familiarize with some of the charasteristics of the taxon.
str(amphibians)
dim(amphibians)
glimpse(amphibians)     

# See what species and how many individuals within taxon
sp.rep <- amphibians%>%
  group_by(scientific_name) %>%
  summarise(species = n())
print(spp_per_group)

# Convert amphibians data into shp file
amphibians.sf <- amphibians%>% 
  select(longitude, latitude, datetime, common_name, 
         scientific_name) %>% 
  st_as_sf(coords=c("longitude", "latitude"), crs=4326) # geometry : POINT

# Check if only the four columns we are interested in are kept. 
dim(amphibians.sf)

# Check of all our observations fall within the area
# some points fall outside of boundaries. --> Need to fix. 
amphibians.out.bound.sf <- amphibians.sf %>% 
  st_intersection(squamish.boundary.sf)
nrow(amphibians.out.bound)

# Determine some arbitrary popup (small boxes containing arbitrary HTML code, 
# that point to a specific point on the map)
amphibians.popup.sf <- amphibians.sf %>% 
  mutate(popup_html = paste0("<p><b>", common_name, "</b><br/>",
                             "<i>", scientific_name, "</i></p>",
                             "<p>Observed: ", datetime, "<br/>",
                            "style=width:100%;/></p>"))

# Create HTML tags                                                 
htmltools::p("iNaturalist Observations in Squamish",
             htmltools::br(),
             amphibians.sf$datetime %>% 
               as.Date() %>% 
               range(na.rm = TRUE) %>% 
               paste(collapse = " to "),
             style = "font-weight:bold; font-size:110%")
             

===================== 4) Check and treat building permits data ================

# Familiarize with sf file's CRS type, columns, and geometry. 
str(build.perm.sf)
names(build.perm.sf)
st_crs(build.perm.sf)
build.perm.sf$geometry    #very strange geometry system. 

# Data files' CRS must be identical for the mapping to work. 
# See CRS for other data files. 

st_crs(squamish.boundary.sf)
st_crs(amphibians.sf). 

# build.perm.sf's CRS is different than squam.boundary and Inaturlist. 
# Convert weird coordinate system to the same as squam.boundary and Inaturlist
#(WGS84, EPS=4326)
build.perm.sf.WPS84 <- build.perm.sf %>% st_transform(4326)

st_crs(build.perm.sf.WPS84)

# Determine some arbitrary popup (small boxes containing arbitrary HTML code, 
# that point to a specific point on the map)
build.popup.sf <- build.perm.sf.WPS84 %>% 
  mutate(popup_html = paste0("<p><b>", Issued_Dat, "</b><br/>",
                             "<i>", Folder_Typ, "</i></p>",
                             "<p>Observed: ", Project_Na, "<br/>",
                             "style=width:100%;/></p>"))
                             
                             
# Create HTML tags                              
htmltools::p("Building Permits in Squamish",
             htmltools::br(),
             build.perm.sf.WPS84$Issued_Date %>% 
               as.Date() %>% 
               range(na.rm = TRUE) %>% 
               paste(collapse = " to "),
             style = "font-weight:bold; font-size:110%")                                                          
                             
                             
                             
                         
========================= 5)Mapping using leaflet =============================================         

# Bring iNaturalist observations and buidling permits together by compiling addCircleMarkers arguments

leaflet(squamish.boundary.sf) %>% 
  addProviderTiles("Esri.WorldStreetMap") %>% 
  addPolygons(weight = 1) %>% 
  addCircleMarkers(data = build.popup.sf,
                   popup = ~popup_html, 
                   radius = 2, color = "yellow", weight = 3) %>%
addCircleMarkers(data = amphibians.popup.sf,
                 popup = ~popup_html, 
                 radius = 2, color = "red", weight = 3, )  
                          

========================= 4) Determine quadrats ... ================================================
# ... to count species richness and density and builing permits density at different locations
# within Squamish boundaries. 
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
============================= More inaturalist data to get if I have time to treat them. ============           

#Get Inaturalist data for different taxon in Squamish in 2020 using rinat package
plants <- get_inat_obs (taxon_name = "Plantae", bounds = bounds, year = 2021, 
                        maxresults = 1000)
amphibians <- get_inat_obs (taxon_name = "Amphibia", bounds = bounds, 
                            year = 2021,maxresults = 1000)
birds <- get_inat_obs (taxon_name = "Aves", bounds = bounds, year = 2021, 
                       maxresults = 1000)
fungi <- get_inat_obs (taxon_name = "Fungi", bounds = bounds, year = 2021, 
                       maxresults = 1000)
insects <- get_inat_obs (taxon_name = "Insecta", bounds = bounds, year = 2021, 
                         maxresults = 1000)
arachnids <- get_inat_obs (taxon_name = "Arachnida", bounds = bounds, 
                           year = 2021, maxresults = 1000)
reptiles <-get_inat_obs (taxon_name = "Reptilia", bounds = bounds, year = 2021, 
                         maxresults = 1000)
mammals <- get_inat_obs (taxon_name = "Mammalia", bounds = bounds, year = 2021, 
                         maxresults = 1000)
fish <- get_inat_obs (taxon_name = "Actinopterygii", bounds = bounds, 
                      year = 2021, maxresults = 1000)
molluscs <- get_inat_obs (taxon_name = "Mollusca", bounds = bounds, year = 2021, 
                          maxresults = 1000)

***************************************************************************************************

                                
