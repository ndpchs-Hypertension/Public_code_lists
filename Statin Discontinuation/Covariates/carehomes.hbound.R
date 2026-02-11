###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 26.06.2024

library(here)
library(dplyr)
here()

gold <- read.delim(here("codelists", "readcodes", "medical.txt"))
gold$medcode <- as.numeric(gold$medcode)


# Use grepl to search for "housebound" and "home visit" in 'readterm'
housebound <- grepl("housebound", gold$readterm, ignore.case = TRUE)
home_visit <- grepl("home visit", gold$readterm, ignore.case = TRUE)

# Create new variable 'housebound'
gold$housebound <- as.integer(grepl("housebound|home visit|home|domiciliary", gold$readterm, ignore.case = TRUE) &
                                !grepl("accident|poison|assault", gold$readterm, ignore.case = TRUE))

housebound <- gold%>%
  filter(housebound == 1)

write.csv(housebound, file = here("codelists", "covariates", "housebound.csv"))

### FILTER ON HERE: FOR TIGHT DEFINITION####
housebound_codes <- housebound_all%>%
  filter(medcode %in% c(2495, 100408, 11099, 29555, 31235, 18330, 102625, 106719, 51450))
hv_codes <- housebound_all%>%
  filter(medcode %in% c(6039, 10120, 10069, 29403, 3703, 25724, 1099, 32015, 25727, 6959, 93535, 108211, 106719, 51450))
not_housebound_code <- read.csv(here("Anna", "Read_Codes", "housebound", "not_housebound.csv"))

#In addition script for use in CPRD analysis limits home visit codes to last 12 months. 
#Important given historical shift in visiting patterns as well as fluctuating illness states 

# Create new variable 'care_home'
# Format here allows me to list terms on separate lines 
care_home_terms <- "(nursing home|care home|resident|institution|part 3|part III|welfare|old people|home)"
gold$care_home <- as.integer(grepl(care_home_terms, gold$readterm, ignore.case = TRUE))

table_care_home <- table(gold$care_home)
print(table_care_home)

care_home <- gold%>%
  filter(care_home == 1)

#Keep all terms with no time constraints. Broader definition, will include some temporary residents 
write.csv(housebound, file = here("codelists", "covariates", "care_home.csv"))