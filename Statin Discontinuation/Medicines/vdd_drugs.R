###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 10.07.2024
##Medications - atypical antipsychotics 
library(here)
library(dplyr)
library(readr)
here()

medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))

vdd_names <- c("vitamin d")
medcode_gold$vdd <- as.integer(grepl(paste(vdd_terms, collapse = "|"), medcode_gold$readterm, ignore.case = TRUE))
sum(medcode_gold$vdd)

vdd_terms <- medcode_gold%>%
  filter(vdd == 1)


product_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "product_edit.txt" ))
product_gold<-product_gold%>%
  rename(databasebuild = X)%>%
  select(-X.1)

product_gold$vdd_code <- as.integer(grepl("colecalciferol", product_gold$ingredient, ignore.case = TRUE))
sum(product_gold$vdd_code)
vdd_codes <- product_gold%>%
  filter(vdd_code == 1)

exclusion_terms <- c("vitamins","multivitamin")

vdd_codes <- vdd_codes%>%
  filter(!grepl(paste(exclusion_terms, collapse = "|"), productname, ignore.case = TRUE))


write_csv(vdd_codes, file = here("codelists", "final_def", "vdd_drugs.csv"))
