# Metadata

## Charged vs reported cases (charges_vs_reported_pct.csv)

**Creation date:** 02-06-2021 (DD-MM-YYYY)
**Authors:** 
### Description
This data set contains the number of reported cases, that resulted in charges written as percent. 

### Creation
The data set was generated from the cleaned versions of the crime data sets. We simply calculated a factor in percent for all cells the following way:  

                                      Charged_cases/reported_cases*100

This csv-file is created from the file *1_cleaning_rape_per_capita.R*, found under in *src/wrangling* folder.

### Usage
This data was used to test if there is any correlation between how many percentages of reports that leads to charges and the population density or twitter usage in a municipality. It was also used to perform spatial autocorrelation and to create interactive maps.


### Columns
This dataset contains 1 column in string format naming municipalities.
It also contains 11 columns from year x2010-x2020 with the number of times reported rape cases are charged, written as procent. These cells are saved in a double format.








## charges pr. 10k inhabitants (charges_per_10k.csv)

**Authors:** 

### Description
In this data set can be found factors describing how many charges was registered in each municipality for the years 2010 – 2020 per 10.000 inhabitants.

### Creation
This data set was generated from the cleaned versions of the crime data set concerning itself with charges and the cleaned version of the population data set. To calculate the number of charged rapes per municipalities per 10.000 inhabitants we calculated the following: 

                                charged_cases/population*10.000 

Thus, returning a data set with cells containing a factor for how many rapes were charged in a specific year between 2010-2020 in a specific municipality, multiplied with 10.000.

This data set was also created from the file *1_cleaning_rape_per_capita.R*, found under in the *src/wrangling* folder.

### Usage
This data was used to test if there is any correlation between the number of reports on sexual assaults relative to the population and the population density or twitter usage in a municipality. It was also used to perform spatial autocorrelation and to create interactive maps.


### Columns
This data set contains 1 column naming municipalities in a string format.
Furthermore, does it also contain 11 columns with the years 2010 - 2020 containing double values with a factor of charged rapes per 10,000 inhabitants.










## Reported pr. 10 k inhabitants (reported_pr_10k.csv) 

**Authors:** 

### Description
This data set contains data that is structured and calculated the same way as the data set called charges pr. 10k inhabitants. 

### Creation
The difference between this data set and charges_per_10k is that, instead of using charged cases this data set uses a cleaned version of the reported cases. There by, the calculations are generated as follows:

                            reported_cases/population*10.000 
This data set was also created from the file *1_cleaning_rape_per_capita.R*, found under in the *src/wrangling* folder.


### Usage
This data was used to test if there is any correlation between the number of charges on sexual assaults relative to the population and the population density or twitter usage in a municipality. It was also used to perform spatial autocorrelation and to make interactive maps. 



### Columns
This data set contains 1 column naming municipalities in a string format.
Furthermore, does it also contain 11 columns with the years 2010 - 2020 containing double values with a factor of reported rapes per 10,000 inhabitants.









## Population pr. square kilometre (pop_sqkm.csv) 

**Authors:** 

### Description
This dataset was created based on the datasets above: clean_pop.csv and clean_area-sqkm.csv to get data on the density of the individual municipalities.

### Creation
These two datasets were merged, and the population was divided with the area to get the number of people pr. square kilometre in each municipality: 
                                
                                      population/sqkm. 

This csv-file has been created with the script: *2_pop_density_area.R*, placed in *src/wrangling* folder.

### Usage
This processed data is used for mapping the municipalities with high density. It is also used in correlations tests with charges, reports and reports that results in charges in municipalities. 


### columns
This data set contains 1 column naming municipalities in a string format.
It also contains 11 columns with interger values, in columns named people_pr_sqm2010 - people_pr_sqm2020











## Tweets pr. Municipalities (tweets_per_municipality.csv) 

**Authors:** 

### Description
This is the processed version of the twitter data. It contains a column with all municipalities (called municipality) and a column of every year from 2012 (the first recorded year of the hashtag #metoo being used in Denmark with a geolocation) to 2020. Each cell contains a count value, of how many times the hashtag #MeToo was used in a municipality each year.   

### Creation
The data was created the at 03-06-2021 by using the R-script “3_cleaning_tweets.R”. The script loops through each year in the original twitter data “twitter.rds”. It then converts the latitude and longitude columns to spatial points. It then counts how often a spatial point is within the boundaries of a municipality. It then saves the results as a CSV file “tweets_per_municipality.csv”.

### Usage
The data is used for mapping tweets in each municipality and for calculating correlations between sexual assault statistics and tweets in a municipality. 


### Columns
This data set contains 1 column naming municipalities in a string format.
It also contains columns named after years from 2012 - 2020. All of these columns contain cells with interger values.


