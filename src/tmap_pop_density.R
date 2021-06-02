
# Import libs -------------------------------------------------------------
library(tidyverse)
library(tmap)
library(sf)
setwd("src")

# Read and clean data -----------------------------------------------------
# Read data with population density
pop_sqkm <- read_csv("../data/processed_data/pop_sqkm.csv") 

# Save the column of average density
pop_avg_density <- pop_sqkm %>% select(Kommune, people_pr_sqkm_avg)

#Read the municipalities polygons
municipalities <- readRDS("../data/raw_data/gadm36_DNK_2_sp.rds")
#Read municipalities as a spatial object
municipalities <- st_as_sf(municipalities)
#Give municipaliteis a CRS
municipalities <- st_transform(municipalities, crs = 4326)

#Clean names
municipalities$NAME_2[31] <- "Aarhus"
municipalities$NAME_2[21] <- "Høje-Taastrup"
municipalities$NAME_2[60] <- "Vesthimmerlands"

#Merge data with municipalities
municipalities <- merge(pop_avg_density, municipalities, by.x = "Kommune", by.y = "NAME_2")

#Read municipalities as a spatial object (This is done again since the merge, transforms it to a normal dataframe)
municipalities <- st_as_sf(municipalities)
#Give municipaliteis a CRS
municipalities <- st_transform(municipalities, crs = 4326)

# Create Tmap -------------------------------------------------------------
tmap_mode(mode = "view")
density_map <- tm_shape(municipalities) +
  tm_polygons("people_pr_sqkm_avg", style = "quantile",
              id = "Kommune",
              title = "Average people pr. sqkm from 2010-2020")

tmap_save(density_map, "../output/density_map.html")
