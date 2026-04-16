###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 11.07.2024
##Heart Failure

library(here)
library(dplyr)
library(haven)
library(readr)
here()

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))

hf_medcodes <- read_csv(here("codelists", "readcodes", "internet", "heartfailure.csv"))
hf <- medcode_gold%>%
  filter(medcode %in% hf_medcodes$medcode)

write_csv(hf, file = here("codelists", "final_def", "hf.csv"))

#This list looks quite good, and was combination across three papers including from Clare Taylor 
# Therefore have not rerun search. 
