
#Setting the working directory to the src folder, as the script must be run from there.
#Otherwise will the paths to where the outputs is written not match.
getwd()
setwd("src")


#Loading package
library(tidyverse)


#Loading data and reading it as dataframes
popolation_link <- "https://raw.githubusercontent.com/Chris-Kramer/final_project-CDS/main/data/raw_data/clean_pop.csv"
charged_rape_link <- "https://raw.githubusercontent.com/Chris-Kramer/final_project-CDS/main/data/raw_data/charged_rape.csv"
reported_rape_link <- "https://raw.githubusercontent.com/Chris-Kramer/final_project-CDS/main/data/raw_data/reported_rape.csv"

population <- read_csv(url(popolation_link))
charged_rape <- read_csv2(url(charged_rape_link))
reported_rape <- read_csv2(url(reported_rape_link))




#Removing the two last columns of population data frame, as this does not contain population data.
population <- population[1:99, ]

#Removing the columns 2007, 2008 and 2009, as we do not have that data in the population data frame
reported_rape <- subset(reported_rape, select = -c(`2007`,`2008`, `2009`))
charged_rape <- subset(charged_rape, select = -c(`2007`,`2008`, `2009`))






#Creating empty list to contain the values that should be kept in df's
match_list <- rep()

#runnning through all municipalities in the population data frame.
for (mun in population$Kommune) {
  
  #Returning a list where the number of of the index in population and reported_rape are the same.
  match_list <- c(match_list, match(mun, reported_rape$kommune))
  
}

#Ceeping only the values mathing the indeices of the mathch list.
rep_rape <- reported_rape[match_list, ]

#Dropping na rows
rep_rape <- na.omit(rep_rape)

#dropping duplicates
rep_rape <- rep_rape %>% distinct()




#Adding a column for the whole country 

#Calculating the sum of reported rapes in our data frame
total_rep <- colSums(rep_rape[,2:12])

#Adding a name to total reported rapes
total_rep <- prepend(total_rep, "total_reported_rapes")



#rbinding total_reported_rapes to our charged rape dataframe.
rep_rape <- rbind(rep_rape, total_rep)




rep_rape <- transform(rep_rape, kommune = as.character(kommune),
                                `2010` = as.numeric(`2010`),
                                `2011` = as.numeric(`2011`),
                                `2012` = as.numeric(`2012`),
                                `2013` = as.numeric(`2013`),
                                `2014` = as.numeric(`2014`),
                                `2015` = as.numeric(`2015`),
                                `2016` = as.numeric(`2016`),
                                `2017` = as.numeric(`2017`),
                                `2018` = as.numeric(`2018`),
                                `2019` = as.numeric(`2019`),
                                `2020` = as.numeric(`2020`))





# Resetting match list to be empty again
match_list <- rep()

#runnning through all municipalities in the population data frame.
for (mun in population$Kommune) {
  
  #Returning a list where the number of of the index in population and charged_rape are the same.
  match_list <- c(match_list, match(mun, charged_rape$kommune))
  
}

#Ceeping only the values mathing the indeices of the mathch list.
char_rape <- charged_rape[match_list, ]

#Dropping na rows
char_rape <- na.omit(char_rape)

#dropping duplicates
char_rape <- char_rape %>% distinct()


#Adding a column for the whole country 

#Creating calculating the sum of charged rapes in our data frame
total_char <- colSums(char_rape[,2:12])

#Adding a name to total charged rapes
total_char <- prepend(total_char, "total_charged_rapes")

#rbinding total_charged_rapes to our charged rape dataframe.
char_rape <- rbind(char_rape, total_char)




char_rape <- transform(char_rape, kommune = as.character(kommune),
                                  `2010` = as.numeric(`2010`),
                                  `2011` = as.numeric(`2011`),
                                  `2012` = as.numeric(`2012`),
                                  `2013` = as.numeric(`2013`),
                                  `2014` = as.numeric(`2014`),
                                  `2015` = as.numeric(`2015`),
                                  `2016` = as.numeric(`2016`),
                                  `2017` = as.numeric(`2017`),
                                  `2018` = as.numeric(`2018`),
                                  `2019` = as.numeric(`2019`),
                                  `2020` = as.numeric(`2020`))






#Adding a column for the whole country 

#Creating calculating the sum of the population in our population data frame
total_popu <- colSums(population[,2:12])

#Adding a name to the the total population
total_popu <- prepend(total_popu, "total_population")

#rbinding total_popu to our population dataframe.
population <- rbind(population, total_popu)



population <- transform(population, Kommune = as.character(Kommune),
                                    `2010` = as.numeric(`2010`),
                                    `2011` = as.numeric(`2011`),
                                    `2012` = as.numeric(`2012`),
                                    `2013` = as.numeric(`2013`),
                                    `2014` = as.numeric(`2014`),
                                    `2015` = as.numeric(`2015`),
                                    `2016` = as.numeric(`2016`),
                                    `2017` = as.numeric(`2017`),
                                    `2018` = as.numeric(`2018`),
                                    `2019` = as.numeric(`2019`),
                                    `2020` = as.numeric(`2020`))

###
###    !!! OBS !!!
###
###This piece of code is not nessasary (for now)


#Writing population to csv
#write.csv(population, "../data/raw_data/EMIL_clean_population.csv", row.names = FALSE)




# Deviding the rapes by population and multiplies by 10000 to get a factor of rape per person. In order to do this we are dropping the municipality column
charged_popu <- char_rape[,2:12]/population[,2:12]*10000
reported_popu <- rep_rape[,2:12]/population[,2:12]*10000


# Adding the municipality column again.
charged_popu <- cbind(Municipalities=c(char_rape[,1]), charged_popu)
reported_popu <- cbind(Municipalities=c(rep_rape[,1]), reported_popu)



#Creating a dataframe containing the procentage of how many rapes was charged out of the reported in procent.
charged_reported_rape <- char_rape[,2:12]/rep_rape[,2:12]*100
charged_reported_rape <- cbind(Municipalities=c(char_rape[,1]),charged_reported_rape)




#Writing data frame to csv's

write.csv(charged_popu, "../data/processed_data/EMIL_charged_population.csv", row.names = FALSE)
write.csv(reported_popu, "../data/processed_data/EMIL_reported_popu.csv", row.names = FALSE)
write.csv(charged_reported_rape, "../data/processed_data/EMIL_charged_reported_rape.csv", row.names = FALSE)

