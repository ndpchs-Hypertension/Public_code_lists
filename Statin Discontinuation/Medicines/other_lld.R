###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 26.06.2024
##Cardiovascular Drugs - other lipid-lowering agents

library(here)
library(dplyr)
library(haven)
library(readr)
here()

product_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "product_edit.txt" ))
product_gold<-product_gold%>%
  rename(databasebuild = X)%>%
  select(-X.1)

product_gold$lld_code <- as.integer(grepl("021202|021203|021205|021201", product_gold$bnfchapter, ignore.case = TRUE)) 
sum(product_gold$lld_code)

product_gold$lld_code2 <- as.integer(grepl("alirocumab|evolocumab", product_gold$ingredient, ignore.case = TRUE)) 
sum(product_gold$lld_code2)

lld_code<-product_gold%>%
  filter(lld_code == 1 | lld_code2==1)

#remove combination with statin tablets 
lld_code <- lld_code%>%
  filter(!grepl("statin", ingredient, ignore.case = TRUE))

write_csv(lld_code, file = here("codelists", "final_def", "lipid_drugs.csv"))

