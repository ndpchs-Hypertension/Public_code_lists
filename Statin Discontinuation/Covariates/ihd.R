###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 11.07.2024
##ischaemic Heart Disease 

library(here)
library(dplyr)
library(haven)
library(readr)
here()

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))

mi_lshtm <- read_csv(here("codelists", "readcodes", "internet", "myocard_infarct_lshtm.csv"))
mi_ihd <- read_csv(here("codelists", "readcodes", "internet", "ihd_lshtm.csv"))

ihd <- full_join(mi_lshtm, mi_ihd, by = "medcode")

ihd <- ihd %>%
  mutate(readterm.x = coalesce(readterm.x, readterm.y))
ihd <- ihd%>%
  select(-readterm.y)
ihd<-ihd%>%
  rename(readterm = readterm.x)

ihd_terms <- c("ischaem", "angin", "myocard", "infarct", "coronary", "heart attack",
               "heart", "angioplast", "ventricul", "cardia", "thrombosis", "ecg", "troponin", "dressler", "atheroscle","prinzmeta",
               "transmural", "aneurysm")
medcode_gold$ihd <- as.integer(grepl(paste(ihd_terms, collapse = "|"), medcode_gold$readterm, ignore.case = TRUE))
sum(medcode_gold$ihd)

ihd_gold <- medcode_gold%>%
  filter(ihd==1)
ihd_gold_review <- anti_join(ihd_gold, ihd, by = "medcode")

#reviewed this list for all codes with clinical events >5000. Nil additional codes to add 
#conclude LSHTM lists are good to use. 

#remove codes not needed 
ihd<- ihd%>%
  filter(medcode != 43984)

#save code list 
write_csv(ihd, file = here("codelists", "final_def", "ihd.csv"))
