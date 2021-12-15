Warning: Project in progress.

Welcome to the Development-and-Biodiversity---Squamish wiki!

Project question : What is the correlation between the number of building permits and the number of amphibian observations in Squamish?

I used public data from two main sources in order to understand the correlation between urbanization and amphibian abundance (as measured by the number of iNaturalist observations) in Squamish. 
Data about the number of building permits that have been granted in 2021 were collected from Squamish municipality’s public database. 
Data about amphibian abundance were collected from the iNaturalist platform using the package  rinat.

The following packages were used for the treatment and mapping of spatial data: map, stmap, ggmap, dplyr, leaflet, conflicted, ggplot. 
The following libraries were then opened: rinat sf, dplyr, tmap, leaflet, conflicted, ggplot2.

This project consists of mapping the distribution of building permits and observation of amphibians using  R (version 4.1.2; 2021-11-01) and to create quadrants from which data can be easily extracted to conduct a correlation analysis.

Quadrants still need to be fixed to fit exactly the same area.
All statistical test are therefore to take with great caution so far. 

The provisionnary measure of the correlation between building permits and amphibian osbervations is made using a Pearson's correlation coefficient.
