###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 26.06.2024
## Cardiovascular Drugs - all antihypertensives 

library(here)
library(dplyr)
library(haven)
library(readr)
here()

aht_all <- read.csv(here("codelists", "readcodes", "rik", "antihypertensives", "antihypertensive_codes.csv"))
aht_rv <- read.csv(here("codelists", "readcodes", "rik", "antihypertensives", "antihypertensive_codes_rvdv.csv"))

aht_exclude <- anti_join(aht_all, aht_rv, by = "prodcode")
table_exclude_class <- table(aht_exclude$drug_type)
print(table_exclude_class)

#Rik just excluded vd used for ED.

table_class <- table(aht_rv$drug_type)
print(table_class)

#Check other classes
#1. Ace Inhibitors
ace_inhibs <- read.delim(here("codelists", "readcodes", "sarah", "ace_inhibs_gold.txt"))

product_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "product_edit.txt" ))
product_gold<-product_gold%>%
  rename(databasebuild = X)%>%
  select(-X.1)

product_gold$acei_code <- as.integer(grepl("2050501", product_gold$bnfchapter, ignore.case = TRUE)) 

product_gold <- product_gold %>%
  mutate(acei_term = case_when(
    bnfchapter == "00000000" & grepl("pril", productname, ignore.case = TRUE) ~ 1,
    TRUE ~ 0
  ))
acei_terms <-table(product_gold$acei_term)
print(acei_terms)
acei <- product_gold%>%
  filter(acei_code == 1 | acei_term == 1)

#remove non ACE-inhibitors
acei <- acei %>%
  filter(!grepl("prilocaine", productname, ignore.case = TRUE))
#remove ACE-i not listed in BNF

acei <- acei %>%
  filter(!grepl("cilazapril | moexipril", ingredient, ignore.case = TRUE))

acei_new <- anti_join (acei, ace_inhibs, by = "prodcode")

#Results is 134 prodcodes missing from Sarah's file. Max therapy events 1207
#Conclude that can use Sarah's code. 

# Calculate the total number of observations, range, and mean
summary_stats <- acei_new %>%
  summarise(
    total_observations = n(),
    range_min = min(therapyevents),
    range_max = max(therapyevents),
    mean_value = mean(therapyevents)
  )

# Print the summary statistics
print(summary_stats)

write_csv(ace_inhibs, file = here("codelists", "final_def", "ace_inhibs.csv"))

#For other classes I have not rerun searches with most recent product files 
#2 Alpha Blockers 

alpha_blockers <- read.delim(here("codelists", "readcodes", "sarah", "alpha_blockers_gold.txt"))
table_ab <- table(alpha_blockers$drugsubstancename)
print(table_ab)
#Remove phentolamine
alpha_blockers <- alpha_blockers%>%
  filter(!grepl("phentolamine", drugsubstancename, ignore.case = TRUE))
#save as csv
write_csv(alpha_blockers, file = here("codelists", "final_def", "alpha_blockers.csv"))

#3. ARBs
arb <- read.delim(here("codelists", "readcodes", "sarah", "angiotensin_ii_gold.txt"))
arb_rik <- read.csv(here("codelists", "readcodes", "rik", "antihypertensives", "ARB.csv"))

#same no of observations --> use Sarah's lists
table_arb <- table(arb$drugsubstancename)
print(table_arb)
#all arbs as expected --> can use Sarah's list as per Rik 
write_csv(arb, file = here("codelists", "final_def", "arb.csv"))

#4.Beta Blockers
bb <- read.delim(here("codelists", "readcodes", "sarah", "beta_blockers_gold.txt"))
bb_rik <- read.csv(here("codelists", "readcodes", "rik", "antihypertensives", "BBs.csv"))
#same no of observations --> use Sarah's lists
table_bb <- table(bb$drugsubstancename)
print(table_bb)
#remove BB which are not available in the UK, used in eyedrop form only, or are no longer used due to toxicity 
bb <- bb%>%
  filter(!grepl("carteolol|oxprenolol|practolol", drugsubstancename, ignore.case = TRUE))
write_csv(bb, file = here("codelists", "final_def", "bb.csv"))

#5. Calcium Channel Blockers
ccb <- read.delim(here("codelists", "readcodes", "sarah", "ccbs_gold.txt"))
ccb_rik <- read.csv(here("codelists", "readcodes", "rik", "antihypertensives", "CCB.csv"))
#same no of observations --> use Sarah's lists
table_ccb <- table(ccb$drugsubstancename)
print(table_ccb)
#removal of drugs not used as anti-HTNs and rarely / not available in UK 
ccb <- ccb%>%
  filter(!grepl("perhexiline|lidoflazine", drugsubstancename, ignore.case = TRUE))

write_csv(ccb, file = here("codelists", "final_def", "ccb.csv"))

#6. Centrally Acting 
cent_acting <- read.delim(here("codelists", "readcodes", "sarah", "centrally_acting_gold.txt"))
cent_acting_rik <- read.csv(here("codelists", "readcodes", "rik", "antihypertensives", "central.csv"))
#same no of observations --> use Sarah's lists
table_central <- table(cent_acting$drugsubstancename)
print(table_central)

#all as expected
write_csv(cent_acting, file = here("codelists", "final_def", "cent_acting.csv"))

#7. Renin Inhibitors
renin_inhib <- read.delim(here("codelists", "readcodes", "sarah", "renin_inhibs_gold.txt"))
renin_inhib_rik <- read.csv(here("codelists", "readcodes", "rik", "antihypertensives", "renin_inhib.csv"))
#all as expected
write_csv(renin_inhib, file = here("codelists", "final_def", "renin_inhib.csv"))

#8.Thiazides and Diuretics 
td <- read.delim(here("codelists", "readcodes", "sarah", "thiazides_diuretics_gold.txt"))
td_rik <- read.csv(here("codelists", "readcodes", "rik", "antihypertensives", "thiazides.csv"))
table_td <- table(td$drugsubstancename)
print(table_td)

#all as expected
write_csv(td, file = here("codelists", "final_def", "thiazide_diuretic.csv"))

#9. Vasodilators
vd <- read.delim(here("codelists", "readcodes", "sarah", "vasodilators_gold.txt"))
vd_rik <- read.csv(here("codelists", "readcodes", "rik", "antihypertensives", "vasodilators.csv"))
#red number in Rik's as expected
#agree with Rik's definition so use his file 

table_vd <- table(vd_rik$drugsubstancename)
print(table_vd)

write_csv(vd_rik, file = here("codelists", "final_def", "vasodilators.csv"))






