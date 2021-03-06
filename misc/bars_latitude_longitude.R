# Import libs -------------------------------------------------------------
library(tmaptools)
library(sf)
library(tidyverse)


# Get longitude and latitude ----------------------------------------------
# Get csv
df_bars <- read_csv("../data/raw_data/CVR-bars.csv")

#List of longitudes
lons <- c()
#List of latitudes
lats <- c()
# Loop through every city and zip code of bars
for(i in 1:nrow(df_bars)) {
  # Get results from the query of geocoding
  result <- geocode_OSM(q = paste(df_bars$Postnr[i], df_bars$By[i], sep = ", "), projection = 4326)
  # Get the coordinates from the results as a vector
  coords <- as.vector(result$coords)
  #Get bar name
  # Get longitude
  lon <- coords[1]
  # Get latitude
  lat <- coords[2]
  # Append name, longitude, and latitude to lists
  lons <- append(lons, lon)
  lats <- append(lats, lat)
}

#Create dataframe with longitudes and latitudes
df <- data.frame(lat = lats,
                 lon = lons)

write.csv(df, "../data/processed_data/bars_coords.csv", fileEncoding = "UTF-8")