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
#Load CK or Takeshi codes
#NB I don't think this list is correct for my purposes. Missing citalopram and fluoxetine amongst others

anti.d_ck <- read_csv(here("codelists", "readcodes", "ck","Antidepressants.csv"))
#Load reviewed Manchester codelist
anti.d_man <- read_csv(here("codelists", "readcodes", "internet","antidepressents_manchester.csv"))

anti.d_man <- anti.d_man%>%
  filter(review != "No")%>%
  rename(prodcode = code, productname = description)%>%
  select(prodcode, productname, review)
tab_review <- table(anti.d_man$review)
print(tab_review)
#Only SSRi and Yes remain which is what expecting 

#Now review any codes in CK list 
missing <- anti_join(anti.d_ck, anti.d_man, by = "prodcode")%>%
  select(prodcode, productname)
#The only code missing here is Buspirone. Primarily used for GAD but can be used to augment depression treatment 
product_gold$bus_code <- as.integer(grepl("buspirone|Buspar", product_gold$ingredient, ignore.case = TRUE))
sum(product_gold$bus_code)
bus_codes <- product_gold%>%
  filter(bus_code == 1)%>%
  mutate(review = "Yes")

anti.d_man<- anti.d_man%>%
  rename(name = productname)
anti.d_final <- left_join(anti.d_man, product_gold, by = "prodcode")
anti.d_final <- bind_rows(anti.d_final, bus_codes)

#Drop codes where less than 10 events present. V unlikely chronic px in my participants 
anti.d_final <- anti.d_final%>%
  filter(therapyevents >= 10)
#Select only variables needed
anti.d_final <- anti.d_final%>%
  select(prodcode, productname, review, dmdcode, therapyevents, bnftext)

write_csv(anti.d_final, file = here("codelists", "final_def", "ad.csv"))
