###Search Strategy for CPRD Code List 
##Author Anna Seeley
##Date Created 12.07.2024
##Peripheral Vascular Disease 

library(here)
library(dplyr)
library(haven)
library(readr)
here()

#Load medical dictionary 
medcode_gold <- read.delim(here("CPRD_CodeBrowser_202309_GOLD", "CPRD_CodeBrowser_202309_GOLD", "medical.txt" ))

#Load ref codes 
pad_lshtm <- read_csv(here("codelists", "readcodes", "internet", "pad_lshtm.csv"))
pad_manc <- read_csv(here("codelists", "readcodes", "internet", "manchester.bmjd3590.peripheral-arterial-disease.csv"))

pad1 <- medcode_gold%>%
  filter(medcode %in% pad_lshtm$medcode)

pad2 <- medcode_gold%>%
  filter(readcode %in% pad_manc$code)
pad_manc<-pad_manc%>%
  rename(readcode = code)

#here see that 25 codes from Manchester list are missing
#Interegation for "Emerg bypass bifurc aorta by anastom aorta to iliac artery" with readcode 7A1200
# shows this is not present in CPRD dictionary

pad_missing <- anti_join(pad_manc, pad2, by = "readcode")

medcode_gold$pad <- as.integer(grepl("Emerg bypass bifurc aorta by anastom aorta to iliac artery", medcode_gold$readterm, ignore.case = TRUE))
sum(medcode_gold$pad)

medcode_gold$bifurc <- as.integer(grepl("bifurc", medcode_gold$readterm, ignore.case = TRUE))
sum(medcode_gold$bifurc)

bifurc<- medcode_gold%>%
  filter(bifurc == 1)

# All missing codes are procedures --> likely not included / not of great importance --> exclude 

pad<- rbind(pad1, pad2)
pad <- pad%>%
  arrange(medcode)%>%
  distinct(medcode, .keep_all = TRUE)

#remove unwanted codes
pad <- pad %>%
  filter(!grepl("amputation", readterm, ignore.case = TRUE))
pad <- pad%>%
  filter(clinicalevents > 0)
write_csv(pad, file = here("codelists", "final_def", "pad.csv"))
#Could also remove procedures here which have low clinical event rate
#I have kept in aneurysms. Bit unclear if should include. For more specific list remove
pad_tight <- pad%>%
  filter(!grepl("aneurysm", readterm, ignore.case = TRUE))

write_csv(pad_tight, file = here("codelists", "final_def", "pad_tight.csv"))
