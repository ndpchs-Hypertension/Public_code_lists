###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 08.08.2024
##Falls

library(here)
library(dplyr)
library(haven)
library(readr)
here()


#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))

#Load Sarah falls codes 
falls <- read_delim(here("codelists", "readcodes", "sarah", "falls_gold.txt"))
#This list looks good and has been used extensively by the team
write_csv(falls, file = here("codelists", "final_def", "falls.csv"))
