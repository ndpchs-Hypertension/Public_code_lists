###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 18.07.2024
##Liver Dysfunction

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))
liver_search_terms <- c("hepatitis", "cirrho", "liver", "hepatic", "varices")
liver_codes <- medcode_gold%>%
  filter(grepl(paste0(liver_search_terms, collapse = "|"), readterm, ignore.case = TRUE))

liver_codes <- liver_codes%>%
  filter(!grepl("deliver", readterm, ignore.case = TRUE))

exclusion_terms <- c("vaccin", "immunis", "screening", "Liverpool", "status", "vaginal", "determination", 
                     "fluke", "carrier", "pregnancy", "hepatic flexure", "diagnostic endoscop",
                     "other operation", "PCR negative", "requires a course of", "O/E", "hepatitis A test",
                     "FH:", "hepatitis e serology", "retinal", "U-S", "education", "biopsy", "occupational risk", 
                     "absence of liver", "x-ray", "static scan", "BLED score", "operation", "laparoscopic", 
                     " normal", "contact", "booster", "level", "Band 1", "negative", "varicocele", "clinic", "vulval",
                     " immune", "referral", "perineal", "studies", "serology", "pelvic", "discussion", "perinatal", "excision",
                     "mother", "riedel", "lung", "enlargement", "rna", "drainage", "assay", "ultrasound", "aspiration")
liver_codes <- liver_codes%>%
  filter(!grepl(paste(exclusion_terms, collapse = "|"), readterm, ignore.case = TRUE))
liver_codes <- liver_codes %>%
  filter(clinicalevents >= 10)
#Most exclusion codes refer to lft tests, which are difficult to exclude on terms alone, as want to keep 'abnormal lfts' 

exclusion_codes <- c(3217, 50, 13867, 3256, 7117, 98515, 7199, 3248, 19194, 9684, 110463, 102372, 
                     19355, 106984, 102373, 14106, 31776, 28904, 22792, 11271, 18601, 33428, 14513, 24912,110411,
                     12021,20142, 14305, 34903, 67044, 89146, 14290, 84399, 8337, 2243, 27181, 29243, 11409, 27717, 59270,
                     63116)

liver_codes <- liver_codes%>%
  filter(!medcode %in% exclusion_codes)

write_csv(liver_codes, file = here("codelists", "final_def", "liver.csv"))
