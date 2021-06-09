# Metadata
## Twitter data (twitter.rds)  
**Creation date:** 02-06-2021 (DD-MM-YYYY) 
### Source  
The twitter data have been acquired using the Twitter developer API. We are using the free version of the developer API, which limits how many tweets we can access, and how we can filter queries. However, for the limited scope of this assignment, the free API was adequate. If you wish to reproduce our twitter data using the script (_twitter_scraping.R_), you need to set up a developer account and provide your own API-keys, since we won’t risk getting billed by providing our keys on a public Github repository and violating terms for sensitive data.  
### Cleaning  
Once the data was scraped, we removed all personal information and kept only the geodata. The geodata was gathered by getting name of the location (this gave us more data, than exclusively using exact geolocations) and then converting the string to longitude and latitude with geocode_OSM from tmaptools. We then saved the data frame as a rds-file.  
### Usage  
We are using the data to count how often a tweet containing the hashtag #Metoo is used in a municipality.  
### Problems  
A lot of twitter users do not use geolocation, when sending tweets. Therefore, we were only able to get 991 tweets with some form of geolocation from 2012-2020 
### Columns
See the twitter documentation for a full description of tweet objects: https://developer.twitter.com/en/docs/twitter-api/v1/data-dictionary/object-model/tweet
- **created_at:** The timestamp for when the tweet was tweeted. 
- **bbox_coords:** Bounding box of coordinates of the location. Contains an array of coordinates.  
- **place_name:** The name of the place it was tweeted (Such as Fitness World) as a string.
- **place_full_name:** The full name of where the tweet was tweeted (This is place name and city and country) as a string.  
- **place_type:** What type of place is the place full name (e.g. city) as a string. 
- **latitude:** The latitude coordinates as a double.  
- **longitude:** The longitude coordinate as a double.

## Data on municipalities in Denmark (gadm36_DNK_2_sp.rds)  
**Download date:** 28-05-2021 (DD-MM-YYYY)  
### Source
GADM (University of California, 2018), https://gadm.org/download_country_v3.html, (Choose Denmark level 2 and (sp) to get the same data).  
The data contains a list of all municipalities in Denmark, and their coordinates as multipolygons.  
### Cleaning
This data has not been cleaned but has been used as it is.  
### Usage  
From this dataset we have used its geographical properties (multipolygons), to visualize our data through maps. But it has likewise been used for spatial calculations (such as counting tweets in each municipalities) and for performing autocorrelations.
### Columns
You can read about the columns and more metadata at https://gadm.org/metadata.html  

## Data on population (clean_pop.csv)  
### Source
Danmarks Statistik, https://www.statistikbanken.dk/BY2 (Mark all municipalities and all years, leave the rest unchanged to get similar data,).  
The data contains information on how many inhabitants there is in each municipality from 2010-2020.  
### Cleaning  
This dataset has been cleaned using OpenRefine.  
### Usage  
This dataset has been used together with our crime data sets to create factors of charged and reported rapes per 10.000 people.  
### Columns  
- **Kommune:** The municipality.  
- **2010:** Population in municipality in 2010.  
- **2011:** Population in municipality in 2011.  
- etc. ...
- **2020:** Population in municipality in 2020.  

## Data on area (clean_area-sqkm.csv)  
### Source
Danmarks Statistik, https://www.statistikbanken.dk/ARE207 (Mark all municipalities and all years to get similar data).  
This data set contains information about how large each municipality is in each year from 2010-2021. The metric is square kilometer.   
### Cleaning 
The data has been cleaned using OpenRefine.  
### Usage
This dataset has been used along with the population dataset to calculate a factor for people per square meter in each municipality in order find how urban each municipality is.  
### Columns  
- **Kommune:** The municipality.  
- **2010:** The municipality area in square kilometers in 2010.  
- **2011:** The municipality area in square kilometers in 2011.
- etc. ...  
- **2021:** The municipality area in square kilometers in 2021.    

## Data on sexual assaults charges (charged_rape.csv) 
### Source
Danmarks Statistik, https://www.statistikbanken.dk/STRAF22 (choose all municipalities, rape, charges, and all years, to get similar data). This data contains information about how many charges of sexual assault there was in each municipality from 2007-2021.  
### Cleaning
This datasets was downloaded as an excel file, and was then cleaned and converted to a csv-file.  
### Usage
The two data set has been used to calculate how many reported rapes there where in each municipality per 10.000 citizens distributed in the different municipalities. Furthermore, did we create a third data set containing how many of reported rapes ended in a charge in precent, per municipality.  
### Columns  
- **Kommune:** The municipality.  
- **2010:** The number of charges in the municipality in 2010.  
- **2011:** The number of charges in the municipality in 2011. 
- etc. ...  
- **2021:** The number of charges in the municipality in 2020.

## Data on sexual assaults reports (reported_rape.csv) 
### Source
Danmarks Statistik, https://www.statistikbanken.dk/STRAF22 (choose all municipalities, rape, reports, and all years, to get similar data). This data contains information about how many police reports of sexual assaults there was in each municipality from 2007-2021.  
### Cleaning
This datasets was downloaded as an excel file, and was then cleaned and converted to a csv-file.  
### Usage
The two data set has been used to calculate how many reported rapes there where in each municipality per 10.000 citizens distributed in the different municipalities. Furthermore, did we create a third data set containing how many of reported rapes ended in a charge in precent, per municipality.  
### Columns  
- **Kommune:** The municipality.  
- **2010:** The number of charges in the municipality in 2010.  
- **2011:** The number of charges in the municipality in 2011. 
- etc. ...  
- **2021:** The number of charges in the municipality in 2020.     

