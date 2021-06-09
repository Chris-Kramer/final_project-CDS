# Sexual Asaults in Danish Municipalities
**Authors:** Christoffer M. Kramer, Emil B. Thomsen, Rasmus V. Hansen.  
**Institution:** Aarhus University, Denmark  
**Course:** Spatial analytics  
**Date:** 09-06-2021 (DD-MM-YYYY)  

## Description
This repository contains all relevant scripts, output, and data for our final project in the course _Spatial analytics_ at Aarhus University. This exploratory analysis uses spatial data to investigate sexual assaults in Danish municipalities.  
## Folders and files
- **data:** Contains all relevant data for this project. It contains two subfolders.  
  - **raw_data:** The raw data, which have only undergone some very light and manual cleaning in order to make it machine-readable. See the readme file in the folder for metadata. 
  - **processed_data:** Data which has been processed. This is the data that is used in the analysis. See the readme file in the folder for metadata. 
- **misc:** Code and experiments which have been excluded from the project. Most of it doesn't work.  
- **output:** Output from the analysis. It contains a mixture of CSV files with results and interactive maps. See the readme file in the folder for metadata.   
- **src:** R scripts that are used in this project. It contains two subfolders. See readme file in the folder for information about how to run the scripts, and to learn more about what output they produce.   
  - **analysis:** The scripts which are used to analyze the data.
  - **wrangling:** The scripts which are used to process the data so it can be used in the analysis.  

## Software
This project was produced in Rstudio with the following versions:  

**Christoffer and Emil (Rstudio local machines):**
- R version 4.0.2 (2020-06-22) 
- Platform: x86_64-w64-mingw32/x64 (64-bit) 
- Running under: Windows 10 x64 (build 19041)  

**Rasmus (Rstudio cloud - worker02 server):** 
- R version 4.0.3 (2020-10-10)
- Platform: x86_64-pc-linux-gnu (64-bit) 
- Running under: Ubuntu 18.04.5 LTS”  

## Packages
The following packages are used in the scripts. Depending on your R version and operating system you might need to install additional dependencies in order to make the packages work.  
- tidyverse 1.3.0 
  - link: https://CRAN.R-project.org/package=tidyverse 
- ggpubr 0.4.0  
  - link: https://CRAN.R-project.org/package=ggpubr
- spdeb 1.1.8  
  - https://CRAN.R-project.org/package=spdeb
- sf 0.9.8  
  - https://CRAN.R-project.org/package=sf
- tmaptools 3.1.1  
   - link: https://CRAN.R-project.org/package=tmaptools
- tmap 3.3.1  
  - link: https://CRAN.R-project.org/package=tmap 
- spatstat 2.1.0
  - link: https://CRAN.R-project.org/package=spatstat
- lubridate 1.7.9
  - https://CRAN.R-project.org/package=lubridate
