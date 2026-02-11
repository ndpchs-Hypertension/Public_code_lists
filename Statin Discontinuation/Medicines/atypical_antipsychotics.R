###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 10.07.2024
##Medications - atypical antipsychotics 
library(here)
library(dplyr)
library(readr)
here()

product_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "product_edit.txt" ))
product_gold<-product_gold%>%
  rename(databasebuild = X)%>%
  select(-X.1)

product_gold$aap_code <- as.integer(grepl("amisulpride|aripiprazole|clozapine|lurasidone|olanzapine|paliperidone|quetiapine|risperidone|sertindole|zotepine", product_gold$ingredient, ignore.case = TRUE))
sum(product_gold$aap_code)
aap_codes <- product_gold%>%
  filter(aap_code == 1)
#check this against BNF codes list
bnfcodes <- read_csv(here("codelists", "bnfcodelist.csv"))
bnfcodes$aap <- as.integer(grepl("amisulpride|aripiprazole|clozapine|lurasidone|olanzapine|paliperidone|quetiapine|risperidone|sertindole|zotepine", bnfcodes$`BNF Product`, ignore.case = TRUE))
sum(bnfcodes$aap)

aap_codes <- product_gold%>%
  filter(aap_code == 1)
#This looks good, no further fine-tuning needed 

write_csv(aap_codes, file = here("codelists", "final_def", "aap.csv"))
