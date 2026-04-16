###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 18.07.2024
##COPD 

library(here)
library(dplyr)
library(haven)
library(readr)
here()

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))

#Load Atrial fibrillation codes - SS original author 
af_codes <- read.delim(here("codelists", "readcodes", "sarah", "Atrial Fibrillation.txt"))

af <- medcode_gold%>%
  filter(medcode %in% af_codes$Medcode)
#remove administration and letters 
af<-af%>%
  filter(!grepl("letter|admin", readterm, ignore.case = TRUE))
#save file
write_csv(af, file = here("codelists", "final_def", "af.csv"))

