###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 17.07.2024
##Cataracts 

library(here)
library(dplyr)
library(haven)
library(readr)
here()

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))

#Load cataract codes
cataract <- read.delim(here("codelists", "readcodes", "ck", "cataract.txt"))
#these are already in format needed so do not need to match them again with medcode_gold 
#remove unwanted codes - referral and absent 
cataract<-cataract%>%
  filter(!grepl("referral|absent", readterm, ignore.case = TRUE))
#save file
write_csv(cataract, file = here("codelists", "final_def", "cataract.csv"))

