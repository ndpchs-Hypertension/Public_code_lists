###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 18.07.2024
##Cancer 

library(here)
library(dplyr)
library(haven)
library(readr)
here()

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))
#Load Constantinos Codes 
cancer_ck <- read_dta(here("codelists", "readcodes", "ck", "cancer groups.dta"))

cancer_codes <- medcode_gold%>%
  filter(medcode %in% cancer_ck$medcode)
#This list is pretty long. Given CK in teh cancer team, satisfied that should work 
write_csv(cancer_codes, file = here("codelists", "final_def", "cancer.csv"))

