###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 26.06.2024
##Medications - interacting drugs 

intdrug_ting <- read.delim(here("codelists", "readcodes", "ting","intdrug.txt"))
#This list has only a few of the drug interactions as listed on the bnf 

#create two lists for each drug
# a. interactions ..> stop or reduce medication 
# b. interactions ..> inc risk of hepatotoxicity

product_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "product_edit.txt" ))
product_gold<-product_gold%>%
  rename(databasebuild = X)%>%
  select(-X.1)

bnfcode_zero <- product_gold%>%
  filter(bnfchapter == "00000000")

statin_interactions <- read_csv(here("codelists", "readcodes", "bnf_statin_interactions.csv"))
statin_heptox <- read_csv(here("codelists", "readcodes", "bnf_statin_heptox.csv"))
# Combine all terms from the interactions column into a single pattern
int_list <- paste(statin_interactions$interactions, collapse = "|")
heptox_list <-paste(statin_heptox$hepatotoxicity, collapse = "|")

#Statin Interactions --> co-prescription of drugs which would mean reduce or stop statin 
# Use grepl to find matching terms in the ingredient column
product_gold$intdrug <- as.integer(grepl(int_list, product_gold$ingredient, ignore.case = TRUE))
sum(product_gold$intdrug)

intdrug <- product_gold%>%
  filter(intdrug == 1)

#remove topical, iv and ocular routes of administration
intdrug<-intdrug%>%
  filter(!grepl("cutaneous|intravenous|ocular|topical|not applicable|transdermal", routeofadministration, ignore.case = TRUE))
intdrug<-intdrug%>%
  select(-ap_code, -coag_code, -coag_term)
write_csv(intdrug, file = here("codelists", "final_def", "statin_intdrug.csv"))

#Statin hepatotoxicity --> co-prescriptions of drugs which would increase risk of hepatotoxicity 
product_gold$heptox <- as.integer(grepl(heptox_list, product_gold$ingredient, ignore.case = TRUE))
sum(product_gold$heptox)

heptox<- product_gold%>%
  filter(heptox == 1)

#remove topical, iv and ocular routes of administration
heptox<-heptox%>%
  filter(!grepl("cutaneous|intravenous|ocular|topical|not applicable|transdermal|inhal", routeofadministration, ignore.case = TRUE))
heptox<-heptox%>%
  filter(!grepl("dressing|injection|powder|water|solution|spray", formulation, ignore.case = TRUE))
heptox<-heptox%>%
  filter(!grepl("ointment|heparinoid", productname, ignore.case = TRUE))

heptox<-heptox%>%
  select(-heptox)

write_csv(heptox, file = here("codelists", "final_def", "heptox_codes.csv"))
