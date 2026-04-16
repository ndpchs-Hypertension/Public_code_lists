###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 17.07.2024
##Palliative and end of life care 

library(here)
library(dplyr)
library(haven)
library(readr)
here()

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))

pall_terms <- c("palliat", "hospice", "end of life", "continuing care")
medcode_gold$pallcare <- as.integer(grepl(paste(pall_terms, collapse = "|"), medcode_gold$readterm, ignore.case = TRUE))
sum(medcode_gold$pallcare)

pallcare <- medcode_gold%>%
  filter(pallcare == 1)

#remove unwanted codes 
exclusion_terms <- c("died", "not required", "discharge from", "severity score", 
                     "pressure ulcer", "except", "discharge by pall",
                     "counselling", "advance care plan", "preferred place",
                     "integrated care priorities", "not indicated", "toolkit", 
                     "declined", "children")
pallcare <- pallcare%>%
  filter(!grepl(paste(exclusion_terms, collapse = "|"), readterm, ignore.case = TRUE))

write_csv(pallcare, file = here("codelists", "final_def", "pallcare.csv"))
