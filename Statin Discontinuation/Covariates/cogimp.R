###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 23.09.2024
##Cognitive Impairment (without dementia)

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))
cogimp_search_terms <- c("memory", "confus", "cogniti", "forget", "remember")

cogimp_codes <- medcode_gold%>%
  filter(grepl(paste0(cogimp_search_terms, collapse = "|"), readterm, ignore.case = TRUE))

exclusion_terms_1 <- c("behaviour", "test", "assessment", 
                     "therapy", "examination", "recall", 
                     "practice", "observations", "scale", "question",
                     "recognition", "rust", "screen", "normal", "verbal",
                     "medication", "procedural", "important", "approach",
                     "autobiograph", "evaluation", "good", "clinic", 
                     "no problem", "transient", "average", "intact",
                     "training", "aided", "skills", "sharp", "recovery", "topographical",
                     "intervention")
exclusion_terms_2 <- c( "BP", "Auditory","Able", "NHS" )

exclusion_codes <- c(52784, 53012, 52799, 91077, 91078, 52788, 52824, 52781, 52791, 52785, 52789, 52786, 52787, 49165, 104864, 70723, 94311)

cogimp_codes <- cogimp_codes%>%
  filter(!grepl(paste(exclusion_terms_1, collapse = "|"), readterm, ignore.case = TRUE))%>%
  filter(!grepl(paste(exclusion_terms_2, collapse = "|"), readterm, ignore.case = FALSE))%>%
  filter(!medcode %in% exclusion_codes)

write_csv(cogimp_codes, file = here("codelists", "final_def", "cogimp.csv"))


