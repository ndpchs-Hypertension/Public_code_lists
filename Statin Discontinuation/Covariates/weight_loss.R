###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 08.08.2024
##Weight Loss 

library(here)
library(dplyr)
library(haven)
library(readr)
here()

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))

#Load CK weight loss codes
wt_ck <- read_dta(here("codelists", "readcodes", "ck", "Weightloss.dta"))
#Load eFI weight loss codes for comparison
wt_efi <- read_dta(here("medcodes for efi", "eFI medcodes Rik", "frailty_codes_35.dta"))

wt_codes <- medcode_gold%>%
  filter(medcode %in% wt_efi$medcode | medcode %in% wt_ck$medcode)

wt_codes<-wt_codes%>%
  filter(!grepl("underweight|body mass|ideal", readterm, ignore.case = TRUE))
write_csv(wt_codes, file = here("codelists", "final_def", "wtloss.csv"))
