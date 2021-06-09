# Metadata
## Twitter data (twitter.rds)  
**Creation date:** 02-06-2021 (DD-MM-YYYY)
**Authors:** 
### Source  
The twitter data have been acquired using the Twitter developer API (twitter.com, n.d.). We are using the free version of the developer API, which limits how many tweets we can access, and how we can filter queries. However, for the limited scope of this assignment, the free API was adequate. If you wish to reproduce our twitter data using the script (_twitter_scraping.R_), you need to set up a developer account and provide your own API-keys, since we won’t risk getting billed by providing our keys on a public Github repository and violating terms for sensitive data.  
### Cleaning  
Once the data was scraped, we removed all personal information and kept only the geodata. The geodata was gathered by getting name of the location (this gave us more data, than exclusively using exact geolocations) and then converting the string to longitude and latitude with geocode_OSM from tmaptools. We then saved the data frame as a rds-file.  
### Usage  
We are using the data to count how often a tweet containing the hashtag #Metoo is used in a municipality.  
### Problems  
A lot of twitter users do not use geolocation, when sending tweets. Therefore, we were only able to get 991 tweets with some form of geolocation from 2012-2020 
### Columns
- **created_at:** The timestamp dating when the tweet was tweeted. 
