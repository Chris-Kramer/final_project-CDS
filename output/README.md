# Outputs

## Maps
In this output folder can be found 6 maps for 6 different years with the same layers.

<br>

### Layers
The maps have the following layers, which can be chosen by the user.
- Mun_tweets: A visualization of how many tweets with the hashtag #Metoo, was used in each municipality. The classification is set according to Jenks classification.  

- Mun_reported: How many reports on sexual assaults there was in each municipality. The classification is set according to Jenks classification. 

- Mun_charged: How many charges there was in each municipality. The classification is set according to Jenks classification. 

- Mun_charged_vs_reported: What percentage of the reports lead to a charge in each municipality. Note that some municipalities have NA values. This is because that when there are zero reports in a municipality, it is impossible to calculate a percentage, since it is impossible to divide by zero. The classification is set according to Jenks classification. 

- Mun_density: The population density in square kilometre for each municipality. The classification is set according to quantile classification.  

### Source
These maps are created from the script create_tmaps.R and can be found in the folder *src/analysis*




## Correlation test (correlations_test.csv)

### Columns

- __year:__ This csv-file contains 1 column describing which year the correlation test is done for. The values in this columns are written as integers.
- __p_val:__ It contains a column with p-values, written as doubles
- __correlation_coefficient:__ It also contains a correlation_coefficient column, where each cell also contains a double.
- __description:__ Lastly the csv-file contains a column with a description of what we are testing the correlation between. each cell is in a string format.


### Source
This csv-file is created from the script Correlations_test.R and can be found in the *src/analysis* folder.




## Monte Carlo test (results_mc_moran.csv)

## Columns

- __year:__ This csv-file contains 1 column describing which year the autocorrelation test is done for. The values in this columns are written as integers.
- __p_val:__ A column of p-values written as doubles can also be found in the column p-val
- __moran_pattern:__ consists of moran pattern values calculated with a Monte Carlo test. Each cell constists of a double character.
- __description:__ this last column consists of a description of what kind of data we are testing with the autocorrelation.

### Source
The csv-file is created from the script autocorrelation.R and can be found in the *src/analysis* folder.
