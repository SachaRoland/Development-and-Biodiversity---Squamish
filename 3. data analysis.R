# ========= Correlation analysis ==========================================


# Create a data frame from grid data 
# Using tibble() (data_frame runs risks deprecation)
grid.data.frame <- tibble(build.grid$count, amphi.grid$count)
Amphibians <- grid.data.frame$`amphi.grid$count`
Build.perm <- grid.data.frame$`build.grid$count`


# Determine critical t-value 
qt(0.05, 46, lower.tail=FALSE)

# Run Pearson's Correlation test
cor.test(build.grid$count, amphi.grid$count, method = "pearson")

# t-obtained does not exceed t-critical. 
# there is no significant linear correlation between amphibians observations and 
# building permits in Squamish. 
# p- value = 0.2684 --> meaning that there is a 27% probability that our result 
# occurred due to chance. 
# We fail to reject to null-hypothesis. 

# get plot with  number of building permits as the explanatory variable and 
# number of amphibians observation as the response variable. 
plot(Build.perm, Amphibians, xlab ="Building Permits", 
     ylab = "Amphibian Observations")


#========== Extra ==============================================================

# Regression line 
lm(Build.perm ~ Amphibians) # very strange results 
abline(lm(Build.perm ~ Amphibians))
# crazy slope. 
# y-intercepts cannot be interpreted in a meaningful way.
# it is therefore absolutely unsafe to say that the number of building permits 
# has an effect on the number of amphibian observations. 
