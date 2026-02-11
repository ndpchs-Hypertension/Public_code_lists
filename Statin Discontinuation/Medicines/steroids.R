###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 10.07.2024
##Medications - corticosteroids 
library(here)
library(dplyr)
library(readr)
here()

product_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "product_edit.txt" ))
product_gold<-product_gold%>%
  rename(databasebuild = X)%>%
  select(-X.1)

#Searching BNF Codes. I have not used this in the main search, but can see for reference 
bnfcodes <- read_csv(here("codelists", "bnfcodelist.csv"))
bnfcodes$steroid <- as.integer(grepl("prednisolone|hydrocortisone|dexamethasone|cortisone|depomedrone|depo-medrone|deflazacort|efcorteson|hydrocortisone|triamcinolone", bnfcodes$`BNF Product`, ignore.case = TRUE))
sum(bnfcodes$steroid)
bnfsteroid<- bnfcodes%>%
  filter(steroid == 1)
bnfsteroid<-bnfsteroid%>%
  select(-`BNF Section`,
         -`BNF Section Code`,
         -`BNF Chemical Substance`,
         -`BNF Chemical Substance Code`,
         -`BNF Presentation`,
         -`BNF Presentation Code`)
bnfsteroid<-bnfsteroid

product_gold$steroid_code <- as.integer(grepl("prednisolone|hydrocortisone|dexamethasone|cortisone|depomedrone|depo-medrone|deflazacort|efcorteson|hydrocortisone|triamcinolone", product_gold$ingredient, ignore.case = TRUE))
#product_gold$steroid_code2 <- as.integer(grepl("prednisolone|hydrocortisone|dexamethasone|cortisone|depomedrone|depo-medrone|deflazacort|efcorteson|hydrocortisone|triamcinolone", product_gold$productname, ignore.case = TRUE)) 
#I have chosen not to include a search for products which are not properly classified as this brings up a lot of products which are not relevant
#but then difficult to remove e.g. fucibet cream. Missing products that are relevant all have therapy events <1000

sum(product_gold$steroid_code)
steroid_code <- product_gold%>%
  filter(steroid_code == 1) | #steroid_code2 == 1)

table_roa<- table(steroid_code$routeofadministration)
print(table_roa)

steroid_code<-steroid_code%>%
  filter(!grepl("ocular|topical|not applicable|transdermal|auricular|buccal|intravitreal|nasal|oromucosal", routeofadministration, ignore.case = TRUE))

steroid_code<-steroid_code%>%
  filter(!grepl("Cutaneous", routeofadministration, ignore.case = FALSE))

table_roa<- table(steroid_code$routeofadministration)
print(table_roa)

steroid_code <- steroid_code%>%
  filter(!grepl("ointment|eye", formulation, ignore.case = TRUE))

steroid_code <- steroid_code%>%
  filter(!grepl("eye|ear|dental|crm", productname, ignore.case = TRUE))%>%
  select(-steroid_code)

write_csv(steroid_code, file = here("codelists", "final_def", "steroid.csv"))



