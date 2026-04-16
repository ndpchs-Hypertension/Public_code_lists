###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 17.07.2024
##Stroke and TIA 

library(here)
library(dplyr)
library(haven)
library(readr)
here()

medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))
cva_codes <- read_csv(here("codelists", "readcodes", "internet", "cva_lshtm.csv"))

cva <- medcode_gold%>%
  filter(medcode %in% cva_codes$medcode)
#Codes look quite good, just need to decide on reviews

write_csv(cva, file = here("codelists", "final_def", "cva.csv"))
