
# Import libs -------------------------------------------------------------
library(tidyverse)
# Set working directory
setwd("src")


# Read and subset data -----------------------------------------------------
# Read data
area_data <- read.csv("../data/raw_data/clean_area-sqkm.csv", encoding = "UTF-8")
pop_data  <- read.csv("../data/raw_data/clean_pop.csv", encoding = "UTF-8")

# Remove lines with information
area_data <- area_data[-c(100:106),]

# Remove columns 2007-2009 and 2021
area_data$X2007 = NULL 
area_data$X2008 = NULL 
area_data$X2009 = NULL 
area_data$X2021 = NULL 


# Transform data ----------------------------------------------------------
# Merge population and area data by municipality
pop_sqm <- merge(pop_data, area_data, by = "Kommune")

# Using mutate twice, since it returns an error, if all columns are mutated at once  
pop_sqm <- pop_sqm %>% 
  mutate(people_pr_sqm2010 = as.integer(X2010.x) / as.integer(X2010.y)) %>% 
  mutate(people_pr_sqm2011 = as.integer(X2011.x) / as.integer(X2011.y),
         people_pr_sqm2012 = as.integer(X2012.x) / as.integer(X2012.y),
         people_pr_sqm2013 = as.integer(X2013.x) / as.integer(X2013.y),
         people_pr_sqm2014 = as.integer(X2014.x) / as.integer(X2014.y),
         people_pr_sqm2015 = as.integer(X2015.x) / as.integer(X2015.y),
         people_pr_sqm2016 = as.integer(X2016.x) / as.integer(X2016.y),
         people_pr_sqm2017 = as.integer(X2017.x) / as.integer(X2017.y),
         people_pr_sqm2018 = as.integer(X2018.x) / as.integer(X2018.y),
         people_pr_sqm2019 = as.integer(X2019.x) / as.integer(X2019.y),
         people_pr_sqm2020 = as.integer(X2020.x) / as.integer(X2020.y),)

# Delete unnecessary folders 
pop_sqm[2:23] = NULL

# Remove the row with Christiansø as there is no data
pop_sqm <- pop_sqm %>% filter(Kommune != "Christiansø")

# Reset the index after removing Christiansø
# Otherwise there will be a missing index
row.names(pop_sqm) <- NULL

# Create a column with the average density across all years 
pop_sqm$people_pr_sqkm_avg <- as.integer(rowMeans(pop_sqm[3:ncol(pop_sqm)]))

# Round the numbers in dataframe to whole numbers
pop_sqm <- pop_sqm %>% 
  mutate_if(is.numeric, round)

# Creating a csv file 
write.csv(pop_sqm, "../data/processed_data/pop_sqkm.csv", fileEncoding = "UTF-8")
