# set current file dir as working dir
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# Import libs -------------------------------------------------------------
library(tidyverse)
library(spdep)
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
municipalities <- st_transform(municipalities, crs = 32632)

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
mun_charged_vs_reported <- st_as_sf(mun_charged_vs_reported)
mun_charged_vs_reported <- st_transform(mun_charged_vs_reported, crs = 32632)
mun_charged <- st_as_sf(mun_charged)
mun_charged <- st_transform(mun_charged, crs = 32632)
mun_reported <- st_as_sf(mun_reported)
mun_reported <- st_transform(mun_reported, crs = 32632)

# Transform to long format, this is easier to work with in this context
# The long format makes it easier to filter based on values rather than columns
# Moreover, I can give all columns the same names, which makes it easier put them into a loop
mun_charged_vs_reported <- gather(mun_charged_vs_reported, year, val, X2010:X2020)
mun_charged <- gather(mun_charged, year, val, X2010:X2020)
mun_reported <- gather(mun_reported, year, val, X2010:X2020)


# function for making a monte carlo simulation ----------------------------
run_mc_test <- function(df, year_val, data_test){
  # Get relevant columns
  df <- df %>% select(Municipalities, year, val)
  # Filter based on year
  df <- df %>% filter(year == year_val)
  # Remove na's
  df <- df %>%  filter(!is.na(val))
  
  #Simplify spatial object
  df <- st_cast(st_simplify(df, dTolerance = 250), to = "MULTIPOLYGON")
  #Find neighbours based on queen movement
  nb <- poly2nb(df$geometry)
  #Get center of each municipality
  centers <- st_coordinates(st_centroid(df$geometry))
  res <- moran.mc(df$val, nb2listw(nb, zero.policy = TRUE), zero.policy = TRUE, 
           nsim = 999)
  
  year_val <- str_remove(year_val, "X")
  df_res <- data.frame(p_val = as.double(res$p.value),
                      moran_pattern =as.double(res$statistic),
                      year = as.integer(year_val),
                      description = as.character(data_test))
  return(df_res)
}

# Get a list of all years (all dfs have the same values so it doesn't matter, which one we pick) 
years <- unique(mun_charged_vs_reported$year)
# Loop through all years and perform autocorrelation ----------------------
# Autocorrelation on reports that leads to charges in a municipality
res_charged_reported <- data.frame(p_val = double(), moran_pattern = double(), year = integer(), description = character())
for(year in years) {
  row <- run_mc_test(mun_charged_vs_reported, year, "Charges that leads to reports")
  res_charged_reported <-rbind(res_charged_reported, row)
}
print("Results from autocorrelation on reports that leads to charges ...")
res_charged_reported #Print out results

res_reports <- data.frame(p_val = double(), moran_pattern = double(), year = integer(), description = character())
#Reports in a municipality
for(year in years){
  row <- run_mc_test(mun_reported, year, "Reports in municipalities")
  res_reports <-rbind(res_reports, row)
}
print("Results from autocorrelation on reports in municipalities...")
res_reports #Print out results

# Create empty df for results
res_charged <- data.frame(p_val = double(), moran_pattern = double(), year = integer(), description = character())
# Charges in a municipality
for (year in years) {
  row <- run_mc_test(mun_charged, year, "Charges in municipalities")
  res_charged <-rbind(res_charged, row)
}
print("Results from autocorrelation on charges in municipalities ...")
res_charged #Print out results

# Merge dataframes and save a csv-file with output
output_csv <- rbind(res_charged, res_reports)
output_csv <- rbind(output_csv, res_charged_reported)

write.csv(output_csv, "../../output/results_mc_moran.csv")