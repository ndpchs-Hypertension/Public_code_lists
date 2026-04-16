###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 23.08.2024
## Familial Hypercholesterolaemia 

library(here)
library(dplyr)
library(haven)
library(readr)
here()

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))
#read codes for FH taken from this paper https://bjgp.org/content/bjgp/early/2023/08/01/BJGP.2023.0010.full.pdf

#read codes C320000, C320.11

fh_codes <- medcode_gold %>%
  filter(readcode == "C320000" | readcode == "C320.11")

write_csv(fh_codes, file = here("codelists", "final_def", "fhchol.csv"))

