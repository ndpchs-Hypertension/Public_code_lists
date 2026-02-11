###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 26.06.2024
##Cardiovascular Drugs - anticoagulants

library(here)
library(dplyr)
library(haven)
library(readr)
here()

anticoag_rik <- read.delim(here("codelists", "readcodes", "rik","anticoagulant.txt"))

product_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "product_edit.txt" ))
product_gold<-product_gold%>%
  rename(databasebuild = X)%>%
  select(-X.1)

product_gold$coag_code <- as.integer(grepl("2080200", product_gold$bnfchapter, ignore.case = TRUE)) 
sum(product_gold$coag_code)
coag_code <- product_gold%>%
  filter(coag_code == 1)

product_gold$coag_term <- as.integer(grepl("xaban", product_gold$ingredient, ignore.case = TRUE)) 
sum(product_gold$coag_term)
coag_term <- product_gold%>%
  filter(coag_term == 1)

# List appears much as Rik's list --> use his with no amendments. 
write_csv(anticoag_rik, file = here("codelists", "final_def", "anticoagulants.csv"))