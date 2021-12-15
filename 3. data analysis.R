# In order to see wether buidling permits is negatively correlated with amphibian species occurence
# We need to run a correlation analysis using Pearson's correlation coefficient. 


# explain what steps would need to be taken to actually measure biodiversity. 
# How would we deal with all the taxa? 
# what kind of fucnction? --> Shannon's index. 


# Use objects used to create the quadrants to create a data frame. 
# Since the grid is the same for both amphibians and buiding permit data points, the order of grid cell 
# is the same. The the numbers of data point for each variables are thus sort of paired within each quadrant.

# Create a data frame using tibble()
grid.data.frame <- tibble(build.grid$count, amphi.grid$count)

#Should be able to get a bird.grid$count that can be combine to amphibians. 
# all.taxa and build.grid would then become new data frame for stat analysis.

# get plot with  number building permits as the explanatory variable and 
# amphibian occurrence as the response variable. 
plot(grid.data.frame)

# Do a mini correlation test
cor(amphi.grid$count, build.grid$count, method = "pearson") 
