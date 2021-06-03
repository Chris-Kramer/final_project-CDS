# Import libs -------------------------------------------------------------
library(tidyverse)
library(tmap)
library(sf)
library(tmaptools)
setwd("src")

# Read and clean data -----------------------------------------------------
# Read data with population density
pop_sqkm <- read_csv("../data/processed_data/pop_sqkm.csv") 
# Save the column of average density
pop_avg_density <- pop_sqkm %>% select(Kommune, people_pr_sqkm_avg)

# Read data with crime statistics
charged_vs_reported <- read.csv("../data/processed_data/charged_vs_reported_pct.csv")
charged <- read.csv("../data/processed_data/charges_per_10k.csv")
reported <- read.csv("../data/processed_data/reported_per_10k.csv")

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

#Create data layers
#Population density
mun_density <- merge(pop_avg_density, municipalities,
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


#Transform layers to spatial objects and give them a crs
mun_density <- st_as_sf(mun_density)
mun_density <- st_transform(mun_density, crs = 4326)
mun_charged_vs_reported <- st_as_sf(mun_charged_vs_reported)
mun_charged_vs_reported <- st_transform(mun_charged_vs_reported, crs = 4326)
mun_charged <- st_as_sf(mun_charged)
mun_charged <- st_transform(mun_charged, crs = 4326)
mun_reported <- st_as_sf(mun_reported)
mun_reported <- st_transform(mun_reported, crs = 4326)

# Create tmaps ------------------------------------------------------------
#Get name of the year columns (2015-2020)
year_cols <- colnames(mun_charged)[7:12]

# Loop through every column of year and create a tmap
for (year in year_cols) {
  
  tmap_mode(mode = "view")
  # Remove x from year name
  year_name <- str_sub(year, 2, str_length(year))
  
  # Density layer
  out_map <- tm_shape(mun_density) +
    tm_layout(title = paste("Sexual assaults in Denmark: ", year_name)) +
    tm_polygons("people_pr_sqkm_avg", style = "quantile",
                palette = "Greens",
                id = "Kommune",
                title = "Average people pr. sqkm from 2010-2020",
                popup.format = list()) +
    
    #Charged contra reported layer
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
                popup.format = list())
  # Save tmap
  tmap_save(out_map, filename = paste("../output/map_", year_name, ".html"))
}

