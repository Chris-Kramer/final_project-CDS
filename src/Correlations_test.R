
# Load Libraries ----------------------------------------------------------

library(tidyverse)
library(ggpubr)


# Read data ---------------------------------------------------------------
setwd("src")
charged <- read_csv("../data/processed_data/charges_per_10k.csv")
pop_sq <- read_csv("../data/processed_data/pop_sqkm.csv")

# We delete to rows to match the population csv where Christiansø is not available 
charged <- charged %>% filter(Municipalities != "Christiansø")
charged <- charged %>% filter(Municipalities != "total_charged_rapes")

# Sort the data with order
charged <- charged[order(charged$Municipalities),]
pop_sq <- pop_sq[order(pop_sq$Kommune),]

# Reset index
row.names(charged) <- NULL


# Run correlation for charged crimes and population density ------------------------------
# For this we look at 2017 
cor(charged$X2017, pop_sq$people_pr_sqm2017, method = c("pearson", "kendall", "spearman"))

# Create new dataframes for 2017 and merging
charged_2017 <- charged %>% select(Municipalities, X2017)
pop_density_2017 <- pop_sq %>% select(Kommune, people_pr_sqm2017)
df_2017 <- merge(charged_2017, pop_density_2017, by.x = "Municipalities", by.y = "Kommune")

# Plot the correlation with ggscatter
ggscatter(df_2017, x = "people_pr_sqm2017", y = "X2017", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "People pr. km2", ylab = "Cases pr. 10k")



# Correlation for tweets --------------------------------------------------
# Load twitter data for municipalities
tweets <- read_csv("../data/processed_data/tweets_per_municipality.csv")

# Order the same way as the others
tweets <- tweets[order(tweets$municipality),]

# Remove Christiansø
tweets <- tweets %>% filter(municipality != "Christiansø")
#Reset index
row.names(tweets) <- NULL

tweets_2017 <- tweets %>% select(municipality, "2017")
df_tweets_charge_17 <- merge(charged_2017, tweets_2017, by.x = "Municipalities", by.y = "municipality")

df_tweets_charge_17 <- 
  df_tweets_charge_17 %>% 
  rename(
    Y2017 = "2017")

# Plot the correlation with ggscatter
ggscatter(df_tweets_charge_17, x = "X2017", y = "Y2017", 
          add = "reg.line", conf.int = TRUE, 
          cor.coef = TRUE, cor.method = "pearson",
          xlab = "Cases pr. 10k", ylab = "Tweets in municipality")
tweets_2017 <- 
  tweets_2017 %>% 
  rename(
    Y2017 = "2017")

cor(charged$X2017, tweets_2017$Y2017, method = c("pearson", "kendall", "spearman"))
