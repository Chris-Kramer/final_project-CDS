# set current file dir as working dir
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Import libs -------------------------------------------------------------
library(tidyverse)
library(sf)
library(spatstat)
library(spdep)



#Population in each municipality (used for calculating ratios)
population <- read.csv("../../data/raw_data/clean_pop.csv", encoding = "UTF-8")
#Transform it to long format
population <- gather(population, year, population, X2010:X2020)

population <- population %>% rename(Municipalities = Kommune)


# Amount of reported assaults
reported_assaults <- read_csv("../../data/processed_data/reported_per_10k.csv")
#Transform it to long format
reported_assaults <- gather(reported_assaults, year, reported, X2010:X2020)

#Amount of actual charges 
charged_assults <- read.csv("../../data/processed_data/charges_per_10k.csv", encoding = "UTF-8")
#Transform it to long format
charged_assults <- gather(charged_assults, year, charged, X2010:X2020)

#Spatial data with municipalities
municipalities <- readRDS("../../data/raw_data/gadm36_DNK_2_sp.rds")
#Read municipalities as a spatial object
municipalities <- st_as_sf(municipalities)
#Give municipaliteis a CRS
municipalities <- st_transform(municipalities, crs = 4326)

#Clean names
municipalities$NAME_2[31] <- "Aarhus"
municipalities$NAME_2[21] <- "Høje-Taastrup"
municipalities$NAME_2[60] <- "Vesthimmerlands"



charged_vs_reported_pct <-read.csv("../../data/processed_data/charged_vs_reported_pct.csv", encoding = "UTF-8")

#change to long format
charged_vs_reported_pct <- gather(charged_vs_reported_pct, year, repo_vs_char_pct, X2010:X2020)




assaults <- left_join(reported_assaults, charged_assults, by= c("year", "Municipalities"))
assaults <- left_join(assaults, population, by= c("year", "Municipalities"))
#Remove rows with NA (this basically means all years from before 2007 and all regions that aren't municipalities)

#This is done since I only have population data from 2010
assaults <- assaults %>% 
  na.omit()

#Merge data with municipalities
assaults <- merge(assaults, municipalities, by.x = "Municipalities",
                                            by.y = "NAME_2")





assaults <- left_join(assaults, charged_vs_reported_pct, by.x = "Municipalities", by.y = "Municipalities")

#Remove the X that is in front of years
assaults <- assaults %>%
  mutate(year = str_remove(year, "X"))

#Convert string to int in year
assaults <- assaults %>%
  mutate(year = as.numeric(year))

assaults <- subset(assaults, select = c(Municipalities, year, reported,  charged, repo_vs_char_pct, population, geometry))

#Transforming all Na's to 100 procent as we have devided reported = 0 with 0 which returns a Na result. We  interpret this as there have been no reports or charges which equals a 100% of all reports to have been charged.
assaults$repo_vs_char_pct[is.na(assaults$repo_vs_char_pct)] <- 100


#Make assaults a spatial object
assaults <- st_as_sf(assaults)
# Give it the correct crs
assaults <- st_transform(assaults, crs = 32632)




#Selecting unique years
unique_years = unique(assaults$year)
#sorting the list of unique years
unique_years <- sort(unique_years)

library(spdep)

#Defining a function
autocorrelation <- function(column) {
  
  for (year in unique_years) {
    assaults_year <- assaults %>% 
      filter(year == year)
    
    assaults_year <- st_cast(st_simplify(assaults_year, dTolerance = 250), to = "MULTIPOLYGON")
    
    #Find neighbours based on queen movement
    nb <- poly2nb(assaults_year$geometry)
    
    #Get center of each municipality
    centers <- st_coordinates(st_centroid(assaults_year$geometry))
    
    
    
    # Run a Moran on reported cases (as a ratio)
    moran_test <- moran.test(column, nb2listw(nb, style = "W", zero.policy = TRUE), zero.policy = TRUE)
    
    #Run a monte carlo simulation on reported cases (as a ratio)
    monte_carlo <- moran.mc(column, nb2listw(nb, zero.policy = TRUE), zero.policy = TRUE, nsim = 999)
    
    print(paste0("Autocorrelation for the year ", year))
    print(moran_test)
    print(monte_carlo)
    print("\n")
    
  }
  
}

autocorrelation(assaults_year$reported)
autocorrelation(assaults_year$charged)
autocorrelation(assaults_year$repo_vs_char_pct)

