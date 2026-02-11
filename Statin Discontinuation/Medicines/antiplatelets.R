###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 26.06.2024
##Cardiovascular Drugs - antiplatelets

library(here)
library(dplyr)
library(haven)
library(readr)
here()

#load product_gold library

product_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "product_edit.txt" ))
product_gold<-product_gold%>%
  rename(databasebuild = X)%>%
  select(-X.1)

antiplatelet_rik <- read.delim(here("codelists", "readcodes", "rik","antiplatelets.txt"))
antiplatelet_rik$bnfcode2 <- as.numeric(antiplatelet_rik$bnfcode)
table_antiplatelet <- table(antiplatelet_rik$bnfcode2)
print(table_antiplatelet)

#research CPRD dictionary
product_gold$ap_code <- as.integer(grepl("2090000|4070100", product_gold$bnfchapter, ignore.case = TRUE)) 
sum(product_gold$ap_code)
ap_gold <- product_gold%>%
  filter(ap_code == 1)
#select only antiplatelets used for 1ry or 2ry prevention cvd
ap_gold <- ap_gold%>%
  filter(grepl("aspirin|clopidogrel|dipyridamole|prasugrel|ticagrelor", ingredient, ignore.case = TRUE))
#remove preparations clearly for analgesia with combined ingredients 
ap_gold<- ap_gold%>%
  filter(!grepl("codeine|paracetamol|calcium|methocarbamol|citric|caffeine|metoclopramide|citrate|papaveretum",ingredient, ignore.case = TRUE))
#remove injectables 
ap_gold<- ap_gold%>%
  filter(!grepl("inject",formulation, ignore.case = TRUE))
#remove if therapy events = 0
ap_gold <- ap_gold%>%
  filter(therapyevents > 0)
#Check final ingredients
table_ap <- table(ap_gold$ingredient)
print(table_ap)

#NB final list has a lot of different preparations of Aspirin. Likely that many of these are for analgesia, not CV protection, but difficult to differentiate this
#NB Aspirin as analgesia is not 
write_csv(ap_gold, file = here("codelists", "final_def", "antiplatelets.csv"))

dipy <- ap_gold%>%
  filter(grepl("dipyridamole", ingredient, ignore.case = TRUE))

sum(dipy$therapyevents)