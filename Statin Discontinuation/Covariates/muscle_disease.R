###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 08.08.2024
##Muscle Disorders  

library(here)
library(dplyr)
library(haven)
library(readr)
here()

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))

#Load muscle disorder codes
muscle_ting <- read.delim(here("codelists", "readcodes", "ting", "pmd.txt"))
pmd_ting <-  medcode_gold%>%
  filter(medcode %in% muscle_ting$medcode)

#Many terms here need to be removed 
exclusion_terms <- c("O/E", "biopsy", "muscle of", "transfer", "division", "other muscle", "tendon",
                    "spinal muscular atrophy", "stretch", "release", "contracture", "repair", "thenar",
                    "laryngeal", "operation", "duchenne", "becker", "strain", "neck muscle", "back muscle", "atrophy",
                    "excision", "ossif", "repair", "foreign", "transp", "flap", "brachial", "stimulator", "accessory",
                    "ex", "catheter", "calci", "suture", "supinator", "drain", "rotator", "specified muscle", "extensor", "strabismus",
                    "hypoplasia", "absent", "spasm", "intercostal muscle", "prona", "anomaly", "firing", "incision",
                    "diastasis", "^\\[SO\\]", "debride", "gower", "emery")
#NB keep in polymyositis and dermatomyositis as some evidence that v rare side effect/statins can aggrevate sx. 
pmd_codes <- pmd_ting%>%
  filter(!grepl(paste(exclusion_terms, collapse = "|"), readterm, ignore.case = TRUE))

write_csv(pmd_codes, file = here("codelists", "final_def", "muscle.csv"))

##Update for outcomes 
# List before arguably too broad. THe muscle adverse effects from statins are much narrower 
# See references here 
# https://pmc.ncbi.nlm.nih.gov/articles/PMC7903384/
# https://www.thelancet.com/action/showPdf?pii=S0140-6736%2822%2901545-8
# Statin myopathy here: https://www.bmj.com/content/bmj/337/7679/Clinical_Review.full.pdf
# So updated code 

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))

#Load muscle disorder codes
muscle_review <- read.csv(here("codelists", "readcodes", "ting", "muscle_review.csv"))%>%
  filter(aes_rev == 1)
muscle_codes <-  medcode_gold%>%
  filter(medcode %in% muscle_review$medcode)

write_csv(muscle_codes, file = here("codelists", "final_def", "muscle_outcome.csv"))

#Now look for statin exception codes 
statin_codes <- medcode_gold%>%
  filter(grepl("statin|HMG", readterm, ignore.case = TRUE))
remove_statin <- c("somatostatin", "cystatin", "prophylaxis", "offer", "nystatin", "counter")

statin_codes <- statin_codes%>%
  filter(!grepl(paste(remove_statin, collapse = "|"), readterm, ignore.case = TRUE))
  
excepted_codes <- medcode_gold%>%
  filter(grepl("excepted", readterm, ignore.case = TRUE))
keep_excepted <- c("heart", "stroke", "CVD", "CHD", "LVD", "CKD", 
                   "diabetes", "hypertension", "peripheral" )

excepted_codes <- excepted_codes%>%
  filter(grepl(paste(keep_excepted, collapse = "|"), readterm, ignore.case = TRUE))

statin_codes <- bind_rows(statin_codes, excepted_codes)
write_csv(statin_codes, file = here("codelists", "final_def", "statin_exception.csv"))
