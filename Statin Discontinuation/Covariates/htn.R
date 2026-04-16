###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 17.07.2024
##Hypertension 

library(here)
library(dplyr)
library(haven)
library(readr)
here()

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))

bp_terms <- c( "hypertensi", "blood pressure", "BP")
medcode_gold$bp <- as.integer(grepl(paste(bp_terms, collapse = "|"), medcode_gold$readterm, ignore.case = TRUE))
sum(medcode_gold$bp)

bp_gold <- medcode_gold%>%
  filter(bp==1)
#main diff of this list c/w established code lists is that it includes htn monitoring codes
# otherwise go with hdruk 

htn_hdruk <- read_csv(here("codelists", "readcodes", "internet", "htn_hdruk.csv"))
htn<- medcode_gold%>%
  filter(medcode %in%htn_hdruk$code)
#remove unwanted codes 
htn <- htn %>%
  filter(!grepl("high cost|contraceptive|eye|advers|withdraw", readterm, ignore.case = TRUE))

#here unsure whether want to remove code for HTN reviews. Keep in at present - represent ~1million codes
#Discussion supervision 18th July - should include. This means should also include borderline HTN. 
#htn <- htn %>%
#  filter(!grepl("review", readterm, ignore.case = TRUE))

htn<-htn%>%
  select(-bp)
write_csv(htn, file = here("codelists", "final_def", "htn.csv"))

