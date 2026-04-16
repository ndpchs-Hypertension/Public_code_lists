###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 21.08.2024
##alcohol intake

library(here)
library(dplyr)
library(haven)
library(readr)
here()


#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))
alcohol_codes <- read.delim(here("codelists", "readcodes", "ting", "alcohol.txt"))%>%
  select(-readterm, -readcode)

alcohol <- medcode_gold%>%
  filter(medcode %in% alcohol_codes$medcode)

alcohol_2 <- left_join(alcohol_codes, medcode_gold, by = "medcode")

#decided here just to remove the O/E codes
#Could categorise another category here re ex-drinker but not that relevant to this project. 

alcohol_2 <- alcohol_2%>%
  filter(!grepl("O/E", readterm, ignore.case = TRUE))

write_csv(alcohol_2, file = here("codelists", "final_def", "alcohol.csv"))

