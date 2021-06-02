
# Import libs -------------------------------------------------------------
library(rtweet)
library(tidyverse)
library(tidytext)
library(httr)
library(jsonlite)
library(tmaptools)

#set working dir
setwd("src")

# Create a token for API calls --------------------------------------------
# The relevant keys and tokens for members of the study group can be found at our developer portal
# If you aren't a member of the study group, and wish to reproduce this script you need to have a developer account at twitter
mytoken <- create_token(
  app = "metoo_denmark", # The name of our 'app'
  consumer_key = "XXXXX", # The API Key
  consumer_secret = "XXXXX", # The secret API key
  access_token = "", # Access token
  access_secret = "XXXXXX" # Secret acces token
)

# Get tweets --------------------------------------------------------------
# Only 991 tweets can live up to my criterion, so We are far from using all our API limit 
tweets <- search_fullarchive(q = "#metoo place_country:DK", # Get tweets with the hashtag "metoo", that are located in Denmark
                             n = 5000, # Maximum number of tweets to be returned 
                             env_name = "metoo", # The name of our developer environment
                             fromDate = 201001010001, # Timestamp: 2010-01-01 00:01
                             toDate = 202101010001, # Timestamp: 2021-01-01 00:01
                             token = mytoken)


# Clean and save file ---------------------------------------------------------------
tweets <- tweets %>% select(created_at, bbox_coords, place_name, place_full_name, place_type)
# Remove place with fitness world (This can't be converted to a geocode)
tweets <- tweets %>% filter(place_full_name != "Fitness World")

#List of longitudes
lons <- c()
#List of latitudes
lats <- c()
# Loop through every city and zip code of bars
for(i in 1:nrow(tweets)) {
    print(tweets$place_full_name[i])
  # Get results from the query of geocoding
  result <- geocode_OSM(q = tweets$place_full_name[i], projection = 4326)
  # Get the coordinates from the results as a vector
  coords <- as.vector(result$coords)
  # Get longitude
  lon <- coords[1]
  # Get latitude
  lat <- coords[2]
  # Append name, longitude, and latitude to lists
  lons <- append(lons, lon)
  lats <- append(lats, lat)
}

# Add columns of latitude and longitude to dataframe 
tweets$latitude <- lats
tweets$longitude <- lons

# I need to save the file as an RDS rather than a csv, since csv can't handle multidimensionality (columns with lists)
saveRDS(tweets, "../data/raw_data/twitter.rds")
