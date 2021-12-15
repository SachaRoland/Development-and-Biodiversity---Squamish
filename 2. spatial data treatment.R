#======================= Description ================================================

Coming soon...

#======================= 1)Read raw data ============================================

#Read and transform the Squamish Zones Boundary to spatial coordinates.               
squamish.boundary.sf <- sf::st_read("Zoning_Classification.shp")
   
#Read and transform the Squamish Zones Boundary to spatial coordinates   
build.perm.sf<- sf::st_read("Building_Permits.shp")      

#========================2) Apply Squamish boundary on a map ==========================

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

#================== 3)Extract data from iNaturalist ==============================================

# Now that we know the geographic dimension of Squamish boundary, we extract iNaturalist data 
# for a specific location and a specific time using thr rinat package. 
# In this case I only collect data for amphibians. The same process could be done for all taxa 
# and/or specific species. 

amphibians <-get_inat_obs (taxon_name = "Amphibia", bounds = bounds, year = 2021, 
                         maxresults = 1000)
                         
# Familiarize with some of the charasteristics of the taxon.
str(amphibians)
dim(amphibians)
glimpse(amphibians)     

# See what species and how many individuals within taxon (stay curious ;)
sp.rep <- amphibians%>%
  group_by(scientific_name) %>%
  summarise(species = n())
print(spp_per_group)

# Convert amphibians data into an sf object to get spatial coordinates. 
# select the variables we are interested in.
amphibians.sf <- amphibians%>% 
  select(longitude, latitude, datetime, common_name, 
         scientific_name) %>% 
  st_as_sf(coords=c("longitude", "latitude"), crs=4326) # geometry : POINT

# Check if only the four columns we are interested in are kept. 
dim(amphibians.sf)

# Check if all our observations fall within the Squamish District area
# some points fall outside of boundaries. --> Need to fix. 
amphi.insquam.b.sf <- amphibians.sf %>% 
  st_intersection(squamish.boundary.sf)
# Check how many observations are in the area
nrow(amphibians.out.bound)

#================== 4)Map Inaturalist data using Leaflet ==============================================

# Determine some arbitrary popup (small boxes containing arbitrary HTML code, 
# that point to a specific point on the map). 
#
amphibians.popup.sf <- amphibians.insquamish.sf %>% 
  mutate(popup_html = paste0("<p><b>", common_name, "</b><br/>",
                             "<i>", scientific_name, "</i></p>",
                             "<p>Observed: ", datetime, "<br/>",
                            "style=width:100%;/></p>"), counts = lengths(
                              st_intersects(., amphibians.sf)))
                            

# Generate HTML tags                                                 
htmltools::p("iNaturalist Observations in Squamish",
             htmltools::br(),
             amphibians.sf$datetime %>% 
               as.Date() %>% 
               range(na.rm = TRUE) %>% 
               paste(collapse = " to "),
             style = "font-weight:bold; font-size:110%")

# Map observations of amphibians in red
leaflet(squamish.boundary.sf) %>% 
    addProviderTiles("Esri.WorldStreetMap") %>% 
    addPolygons(weight = 1) %>% 
    addCircleMarkers(data = amphibians.popup.sf,
                                popup = ~popup_html, 
                                radius = 2, color = "red", weight = 3) 
             

#===================== 4) Map building permits data =====================
# we already made an sf object for data about building permits (build.perm.sf)
# Familiarize with sf file's CRS type, columns, and geometry. 
str(build.perm.sf)
names(build.perm.sf)
st_crs(build.perm.sf)
build.perm.sf$geometry    #Notice a different CRS format than for iNaturalist. 


# Data files' CRS must be identical for the mapping to work. 
# Double-check CRS for other data files. 
st_crs(squamish.boundary.sf)
st_crs(amphibians.sf). 

# build.perm.sf's CRS is indeed different than squam.boundary and iNaturalist. 
# Convert weird coordinate system to the same as squam.boundary and iNaturalist
# --> (WGS84, EPS=4326; We can use the EPS code to do so. 
build.perm.sf.WPS84 <- build.perm.sf %>% st_transform(4326)

#check if CRS has been converted properly. 
st_crs(build.perm.sf.WPS84)

# Do the same we did with iNaturalist data for buiding permits data.
# Determine some arbitrary popup (small boxes containing arbitrary HTML code, 
# that point to a specific point on the map)
build.popup.sf <- build.perm.sf.WPS84 %>% 
  mutate(popup_html = paste0("<p><b>", Issued_Dat, "</b><br/>",
                             "<i>", Folder_Typ, "</i></p>",
                             "<p>Observed: ", Project_Na, "<br/>",
                             "style=width:100%;/></p>"))
                            
                             
# Generate HTML tags                              
htmltools::p("Building Permits in Squamish",
             htmltools::br(),
             build.perm.sf.WPS84$Issued_Date %>% 
               as.Date() %>% 
               range(na.rm = TRUE) %>% 
               paste(collapse = " to "),
             style = "font-weight:bold; font-size:110%")   


# Map building permits in yellow
leaflet(squamish.boundary.sf) %>% 
  addProviderTiles("Esri.WorldStreetMap") %>% 
  addPolygons(weight = 1) %>% 
  addCircleMarkers(data = build.popup.sf,
                   popup = ~popup_html, 
                   radius = 2, color = "yellow", weight = 3)
                             
                             
                          
               
#========================= 5) Make one map combining iNaturalist and buidling permits data ====    

# Bring iNaturalist observations and buidling permits together by compiling 
# the addCircleMarkers arguments from the two maps we just made. 

leaflet(squamish.boundary.sf) %>% 
  addProviderTiles("Esri.WorldStreetMap") %>% 
  addPolygons(weight = 1) %>% 
  addCircleMarkers(data = build.popup.sf,
                   popup = ~popup_html, 
                   radius = 2, color = "yellow", weight = 3) %>%
addCircleMarkers(data = amphibians.popup.sf,
                 popup = ~popup_html, 
                 radius = 2, color = "red", weight = 3, ) %>%
addLayersControl(baseGroups = c("Buidling Permits", "Amphibians"),
options = layersControlOptions(collapsed = TRUE))   

#This last function allows us to visualize different layers of the map. 
                          


#========================= 6) Determine quadrants ... ================================================
# ... to count species richness and density and builing permits density at different locations
# within Squamish boundaries. 
# The leaflet package allows us to visualize how many data points are found within each 
# predefined grid cell. 
                                
# Create e grid of polygons (4x12) based on the boundary-box of the points 
# for building permits which are all in Squamish boundary. 
# Using build.perm.sf.WPS84 therefore allows us to plot the grid within the boundary.

grid <- st_make_grid( st_as_sfc( st_bbox(build.perm.sf.WPS84)),
                            n = c(4, 12) ) %>% 
  st_cast( "POLYGON" ) %>% st_as_sf()    

# Count data points in each quadrant within the grid.

# ***** Do it for amphibians *****
amphi.grid$count <- lengths( st_intersects(grid, amphibians.insquamish.sf))

#add color to polygons based on count
color.amphi <- colour_values_rgb(palette = "topo", amphi.grid$count, 
                         include_alpha = FALSE) / 255


# Map quadrants for amphibians 
leaflet() %>% 
  addTiles() %>% 
  leafgl::addGlPolygons(data = amphi.grid,
                         weight = 1,
                         fillColor = color.amphi,
                         fillOpacity = 0.7,
                         popup = ~count, src= 4326) %>%
  addLegend(pal =  colorNumeric (palette = "topo", domain = amphi.grid$count),
            values = amphi.grid$count,
            labFormat = labelFormat(),
            opacity = 0.85, title = "Points counted per quadrant", 
            position = "topright", group = "Taxon")


# ***** Do it for building permits *****
build.grid$count <- lengths( st_intersects(grid, build.perm.sf.WPS84))

#add color to polygons based on count for 
color.build <- colour_values_rgb(palette = "topo", build.grid$count, 
                         include_alpha = FALSE) / 255

#Map quadrants for building permits 
leaflet() %>% 
  addTiles() %>% 
  leafgl::addGlPolygons(data = build.grid,
                        weight = 1,
                        fillColor = color.build,
                        fillOpacity = 0.7,
                        popup = ~count, crs= 4326) %>%
  addLegend(pal =  colorNumeric (palette = "topo", domain = build.grid$count),
          values = build.grid$count,
          labFormat = labelFormat(),
          opacity = 0.85, title = "Points counted per quadrant", 
          position = "topright", group = "Building Permit")






                                
#============================= More inaturalist data to get if I have time to treat them. ============           

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

                                
