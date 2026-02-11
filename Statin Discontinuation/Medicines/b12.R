###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 10.07.2024
##Medications - b12 replacement 
library(here)
library(dplyr)
library(readr)
here()

product_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "product_edit.txt" ))
product_gold<-product_gold%>%
  rename(databasebuild = X)%>%
  select(-X.1)

product_gold$b12_code <- as.integer(grepl("hydroxocobalamin|cyanocobalamin", product_gold$ingredient, ignore.case = TRUE))
sum(product_gold$b12_code)
b12_codes <- product_gold%>%
  filter(b12_code == 1)
#check this against BNF codes list
bnfcodes <- read_csv(here("codelists", "bnfcodelist.csv"))
bnfcodes$b12 <- as.integer(grepl("hydroxocobalamin|cyanocobalamin", bnfcodes$`BNF Product`, ignore.case = TRUE))
sum(bnfcodes$b12)
bnf_b12 <- bnfcodes%>%
  filter(b12 == 1)

b12_codes <- b12_codes%>%
  mutate(keep_b12 = as.integer(grepl('Drugs Used In Megaloblastic Anaemias', bnftext)))%>%
  filter(keep_b12 ==1)%>%
  select(prodcode, productname, bnfchapter, bnftext)


#This looks good, no further fine-tuning needed 

write_csv(b12_codes, file = here("codelists", "final_def", "b12_drugs.csv"))
