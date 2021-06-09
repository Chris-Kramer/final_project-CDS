# The right order to run scripts in.

Run the scripts in this order, to create the nessasary data:
- 1_cleaning_rape_per_capita.R
- 2_pop_density_area.R
- 3_cleaning_tweets.R


<br>
The script: "twitter_scraping.R", cannot be ran unless you have a dewelloper acount. However you do not need to run it as the data we are using for the rest of the scripts have already been created.



## 1_cleaning_rape_per_capita.R

This script creates the following outputs: 
- charges_per_10k.csv
- reported_per_10k.csv
- processed_data/charged_vs_reported_pct.csv

and can be found in the prossed_data folder.



## 2_pop_density_area.R
This script creates the following output:
- pop_sqkm.csv

and can be found in the processed_data folder.



## 3_cleaning_tweets.R
This script creates the following output:
- tweets_per_municipality.csv

and can be found in the processed_data folder.
