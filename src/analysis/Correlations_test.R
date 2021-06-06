# Load Libraries ----------------------------------------------------------
library(tidyverse)
library(ggpubr)
# set current dir as working dir
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read data ---------------------------------------------------------------
charged <- read_csv("../../data/processed_data/charges_per_10k.csv")
reported <- read_csv("../../data/processed_data/charges_per_10k.csv")
charged_reported <- read_csv("../data/processed_data/charged_vs_reported_pct.csv")
pop_sq <- read_csv("../../data/processed_data/pop_sqkm.csv")
tweets <- read_csv("../../data/processed_data/tweets_per_municipality.csv")

# Clean data --------------------------------------------------------------
# Charges
# Delete to rows to match the population csv where Christiansø is not available and where the total row is unavailable 
charged <- charged %>% filter(Municipalities != "Christiansø")
charged <- charged %>% filter(Municipalities != "total_charged_rapes")

# Reports
reported <- reported %>%filter(Municipalities != "Christiansø")
reported <- reported %>% filter(Municipalities != "total_charged_rapes")

# Charges vs reports
charged_reported <- charged_reported %>% filter(Municipalities != "Christiansø")
charged_reported <- charged_reported %>% filter(Municipalities != "total_charged_rapes")

# Tweets
tweets <- tweets %>% filter(municipality != "Christiansø")

# Sort the data alphabetically with order
charged_reported <- charged_reported[order(charged_reported$Municipalities),]
tweets <- tweets[order(tweets$municipality),]
reported <- reported[order(reported$Municipalities),]
charged <- charged[order(charged$Municipalities),]
pop_sq <- pop_sq[order(pop_sq$Kommune),]

# Reset indexes
row.names(charged) <- NULL
row.names(reported) <- NULL
row.names(charged_reported) <- NULL
row.names(tweets) <- NULL

# Function for performing correlations ------------------------------------
calc_correlations <- function(start_col = 3, x_data, y_data, x_string, y_string) {
  print(paste("----------- Correlations between", x_string, "and", y_string, "-------------------" ))
  for (i in 3:ncol(x_data)) {
    # Get column name
    col_name <- colnames(x_data[,i])
    # Get year without X (this is only used for printing)
    # This solution might seem a bit bizarre
    # However, it ensures, that this function can handle column names with and without X in front of year
    year <- str_sub(col_name, str_length(col_name) - 1 ,str_length(col_name)) # Get last two digits of col name
    year <- paste("20", year, sep = "") # Paste 20 in front of year name
    
    # Make x and y data a nummeric vector (otherwise cor.test won't work)
    x_vect = as.vector(unlist(x_data[,i]))
    y_vect = as.vector(unlist(y_data[,i]))
    
    # Perform correlation test and print results to console
    result <- cor.test(x_vect, y_vect, method = c("pearson", "kendall", "spearman"))
    print(paste("Testing for corrlations between", x_string, "and", y_string,  "in Year", year, "..."))
    print(paste("P-Value:", result$p.value, "- Correlation Coefficient ", result$estimate))
  }
  
}

# Test correlations -------------------------------------------------------
# Correlation between charges and density
calc_correlations(x_data = charged, y_data = pop_sq,
                  x_string = "Charges",
                  y_string = "Population density")

# Correlation between reports and density
calc_correlations(x_data = reported, y_data = pop_sq,
                  x_string = "Reports",
                  y_string = "Population density")

# Correlation between pct. of reports that leads to a charge and density
calc_correlations(x_data = charged_reported, y_data = pop_sq,
                  x_string = "Reports that results in a charge",
                  y_string = "Population density")

# Correlations between tweets in a municipality and sexual assault charges
calc_correlations(x_data = tweets, y_data = charged,
                  x_string = "Charges",
                  y_string = "Tweets in a municipality")

# Correlations between tweets in a municipality and sexual assault reports
calc_correlations(x_data = tweets, y_data = reported,
                  x_string = "Reports",
                  y_string = "Tweets in a municipality")

# Correlation between pct. of reports that leads to a charge and tweets in a municipality
calc_correlations(x_data = tweets, y_data = charged_reported,
                  x_string = "Reports that results in a charge",
                  y_string = "Tweets in a municipality")
