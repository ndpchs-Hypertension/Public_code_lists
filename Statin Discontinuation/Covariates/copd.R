###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 17.07.2024
##COPD 

library(here)
library(dplyr)
library(haven)
library(readr)
here()

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))

copd_terms <- c("copd", "chronic obstructive pulmon", "bronchitis", "emphysem")
medcode_gold$copd <- as.integer(grepl(paste(copd_terms, collapse = "|"), medcode_gold$readterm, ignore.case = TRUE))
sum(medcode_gold$copd)

copd_search <- medcode_gold%>%
  filter(copd==1)
ting_copd <- read.delim(here("codelists", "readcodes", "ting", "copd.txt"))
lshtm_copd <- read_csv(here("codelists", "readcodes", "internet", "copd_lshtm.csv"))

ting_extra <- anti_join(ting_copd, lshtm_copd, by = "medcode")
lshtm_extra <- anti_join(lshtm_copd, ting_copd, by = "medcode")

copd_combined <- full_join(ting_copd, lshtm_copd, by ="medcode")

copd_codes <- medcode_gold%>%
  filter(medcode %in% copd_combined$medcode)

# on balance after review, going to keep Ting's codes for COPD
# This is a tight definition e.g. no monitoring / letters 

copd_final <- medcode_gold%>%
  filter(medcode %in% ting_copd$medcode)

write_csv(copd_final, file = here("codelists", "final_def", "copd.csv"))

