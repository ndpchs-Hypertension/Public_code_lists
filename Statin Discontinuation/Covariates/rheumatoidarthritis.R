###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 17.07.2024
##Rheumatoid Arthritis

library(here)
library(dplyr)
library(haven)
library(readr)
here()

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))

ra_terms <- c( "rheumatoid", "felty", "caplan")

medcode_gold$ra <- as.integer(grepl(paste(ra_terms, collapse = "|"), medcode_gold$readterm, ignore.case = TRUE))
sum(medcode_gold$ra)

ra_gold <- medcode_gold%>%
  filter(ra==1)

ra_hdruk <- read_csv(here("codelists", "readcodes", "internet", "ra_phenotype_PH80_ver_160_concepts.csv"))
ra_hdruk <- medcode_gold%>%
  filter(medcode %in% ra_hdruk$code)

ra_missing<- anti_join(ra_gold, ra_hdruk, by = "medcode")
#missing codes are mainly either reviews (not clear on specificity here), or that RF has been done / is positive 
#Do not want these codes so stick with HDRUK definition and clean 
# Here removed ref to adult still's disease (as not clearly RA), any pure examination findings, monitoring only of disease 

ra_hdruk<-ra_hdruk%>%
  filter(!grepl("nodule|ulnar|letter|invitation|swan-neck|still's|spindling|rehabilitation", readterm, ignore.case = TRUE))

write_csv(ra_hdruk, file = here("codelists", "final_def", "ra.csv"))
