# set current file dir as working dir
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# Import libs -------------------------------------------------------------
library(tidyverse)
library(tmap)
library(sf)
library(tmaptools)

# Read and clean data -----------------------------------------------------
# Read data with population density
pop_sqkm <- read.csv("../../data/processed_data/pop_sqkm.csv", encoding = "UTF-8") # Using tidyverse, since there are problems with encoding otherwise

# Read data with crime statistics
charged_vs_reported <- read.csv("../../data/processed_data/charged_vs_reported_pct.csv", encoding = "UTF-8")
charged <- read.csv("../../data/processed_data/charges_per_10k.csv", encoding = "UTF-8")
reported <- read.csv("../../data/processed_data/reported_per_10k.csv", encoding = "UTF-8")
tweets <- read.csv("../../data/processed_data/tweets_per_municipality.csv", encoding = "UTF-8")

# Read the municipalities polygons
municipalities <- readRDS("../../data/raw_data/gadm36_DNK_2_sp.rds")
# Read municipalities as a spatial object
municipalities <- st_as_sf(municipalities)
# Give municipaliteis a CRS
municipalities <- st_transform(municipalities, crs = 4326)

# Clean names
municipalities$NAME_2[31] <- "Aarhus"
municipalities$NAME_2[21] <- "Høje-Taastrup"
municipalities$NAME_2[60] <- "Vesthimmerlands"

# Create data layers
# Population density
mun_density <- merge(pop_sqkm, municipalities,
                     by.x = "Kommune", by.y = "NAME_2")
#Reports that leads to charges
mun_charged_vs_reported <- merge(charged_vs_reported, municipalities,
                                 by.x = "Municipalities", by.y = "NAME_2")
# Charges
mun_charged <- merge(charged, municipalities,
                     by.x = "Municipalities", by.y = "NAME_2")
# Reports
mun_reported <- merge(reported, municipalities,
                      by.x = "Municipalities", by.y = "NAME_2")
# Tweets
mun_tweets <- merge(tweets, municipalities,
                    by.x = "municipality", by.y = "NAME_2")

# Transform layers to spatial objects and give them a crs
mun_density <- st_as_sf(mun_density)
mun_density <- st_transform(mun_density, crs = 4326)
mun_charged_vs_reported <- st_as_sf(mun_charged_vs_reported)
mun_charged_vs_reported <- st_transform(mun_charged_vs_reported, crs = 4326)
mun_charged <- st_as_sf(mun_charged)
mun_charged <- st_transform(mun_charged, crs = 4326)
mun_reported <- st_as_sf(mun_reported)
mun_reported <- st_transform(mun_reported, crs = 4326)
mun_tweets <- st_as_sf(mun_tweets)
mun_tweets <- st_transform(mun_tweets, crs = 4326)

# Create tmaps ------------------------------------------------------------
# Get name of the year columns (2015-2020)
year_cols <- colnames(mun_charged)[8:13]
# Loop through every column of year and create a tmap
i <- 8 # Columns with density follows a different naming scheme,
# So I'm using a counter to access the columns for that df
for (year in year_cols) {
  tmap_mode(mode = "view")
  # Remove x from year name (Used for title)
  year_name <- str_sub(year, 2, str_length(year))
  # Map density layer
  out_map <- tm_shape(mun_density) +
    tm_layout(title = paste("Sexual assaults in Denmark: ", year_name)) +
    tm_polygons(colnames(pop_sqkm)[i], style = "quantile", #Getting column name of pop_sqkm, since it does not contain a geom column
                palette = "Greens",
                id = "Kommune",
                title ="People pr. sqkm",
                popup.format = list()) +

    # Charged contra reported layer
    tm_shape(mun_charged_vs_reported) +
    tm_polygons(year, style = "pretty",
                palette = "Blues",
                id = "Municipalities",
                title = "% of reports that results in charges",
                popup.format = list()) +
    
    # Charges layer
    tm_shape(mun_charged) +
    tm_polygons(year, style = "jenks",
                id = "Municipalities",
                title = "Charges pr. 10.000 inhabitants",
                popup.format = list()) +
    
    # Reports layer 
    tm_shape(mun_reported) +
    tm_polygons(year, style = "jenks",
                palette = "Reds",
                id = "Municipalities",
                title = "Reports pr. 10.000 inhabitants",
                popup.format = list()) +

    # Tweets layer
    tm_shape(mun_tweets) +
    tm_polygons(year, style = "jenks",
                palette = "Purples",
                id = "municipality",
                title = "Tweets with hashtage #metoo in muncipality",
                popup.format = list())
  # Save tmap
  tmap_save(out_map, filename = paste("../../output/map_", year_name, ".html"))
  i <- i + 1
}
