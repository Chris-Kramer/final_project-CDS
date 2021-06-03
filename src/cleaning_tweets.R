getwd()
setwd("src")

library(lubridate)
library(spatstat)
library(sf)

#Tæl antal gange der forekommer tweets i forskellige kommuner, under de forskellige år.
#Gem det i en data frame, der har samme format som charges_per_10k

#Downloading twitter data
twitter <- readRDS("../data/raw_data/twitter.rds")

#Transforming the created_at coulmn values to only contain years.
twitter$created_at <- year(twitter$created_at)

#Creating a list with the unique years, in the data frame.
unique_years <- unique(twitter$created_at)


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

#Creating the data frame, that will become the output. Right now it only contains the names of municipalities.
twitter_output <- data.frame(municipality = unique(municipalities$NAME_2))

#Running through unique years.
for (year in unique_years) {
  
  # Saving the year by filtering years out of the created_at column in the twitter data frame.
  twitter_year <- twitter %>% filter(created_at == year)
  
  
  #creating a spatial object from twitter_year
  twitter_spatial <- st_as_sf(x= twitter_year,
                              coords = c("longitude", "latitude"),
                              crs = 4326)
  
  #creating a data frame based on the municipality data frame's column NAME_2, which contains municipalitiy names
  twitter_df <- data.frame(municipality = municipalities$NAME_2)
  
  #making year into a string, as they are going to be columns.
  year_str <- toString(year)
  
  #Creating a new column in twitter_df. Here we count the number of times tweets are made in that municipality and save them in the right column cell.
  twitter_df[,year_str] <- lengths(st_intersects(municipalities$geometry, twitter_spatial$geometry))
  
  #Merging twitter_df and twitter_output to save all the different years in the twitter_output dataframe.
  twitter_output <- merge(twitter_df, twitter_output,
                          by = "municipality", )
  
}

# Rearranging the columns to be in the right order.
twitter_output <- twitter_output[c("municipality", "2012", "2013", "2015", "2016", "2017", "2018", "2019", "2020")]



#writing to csv-file
write.csv(twitter_output, "../data/processed_data/tweets_per_municipality.csv", fileEncoding = "UTF-8")
