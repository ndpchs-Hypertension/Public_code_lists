###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 17.07.2024
##CKD

library(here)
library(dplyr)
library(haven)
library(readr)
here()

#Using here definition of CKD used for Qrisk 2 and 3 i.e. CKD 3 or higher or sig nephropathy

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))

hdruk_ckd_codes <- read_csv(here("codelists", "readcodes", "internet", "ckd_phenotype_PH920_ver_1919_concepts.csv"))
ckd_ting <- read.delim(here("codelists", "readcodes", "ting", "kd.txt"))
hdruk_ckd <- medcode_gold%>%
  filter(readcode %in% hdruk_ckd_codes$code)

ckd_ting_new <- medcode_gold%>%
  filter(medcode %in% ckd_ting$medcode)
#Quite a lot of codes need to be cleaned
#Exclude CKD1, 2 and any monitoring or invitation for monitoring codes 
#Remove AKI or when not clear if acute / chronic 
#Remove vague codes about dialysis equipment 
#Remove pyelonephritis. 

exclusion_terms <- c("apparatus", "monitoring", "uraemi", "maternal", 
                     "acute pyelonephrit", "unspecified pyeloneph", "pyonephrit", 
                     "anaemi", "acute renal failure", "acute drug-induced", "lines", "phosphat", "training", "catheter")
exclusion_medcodes <- c(29013, 12586, 19473, 95572, 95121, 
                        9379, 48475, 8098, 16929, 36273, 23773, 
                        251, 239, 57919, 57100, 11992, 56896, 96724, 6842, 6774)
excluded_ckd<-ckd_ting_new%>%
  filter(grepl(paste(exclusion_terms, collapse = "|"), readterm, ignore.case = TRUE) |
                 medcode %in% exclusion_medcodes)
#Can view excluded terms 
View(excluded_ckd)
arrange(excluded_ckd, desc(excluded_ckd$clinicalevents))

ckd_ting_new <- ckd_ting_new%>%
  filter(!grepl(paste(exclusion_terms, collapse = "|"), readterm, ignore.case = TRUE))%>%
  filter(!medcode %in% exclusion_medcodes)

write_csv(ckd_ting_new, file = here("codelists", "final_def", "ckd.csv"))

  