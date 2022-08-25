# LOAD PACKAGES ----------------------------------------------------------------------------------- 

library(bookdown)
library(data.table)
library(ggmap)
library(RgoogleMaps)
library(shiny)
library(leaflet)
library(tidyverse)
library(readxl)

# IMPORT DATA FILES -------------------------------------------------------------------------------- 

# import excel files

excel_files <- data.frame(files = list.files("data/", pattern='*.xlsx', full.names = TRUE)) %>% 
               mutate(., df_name = str_extract(files, '(?<=data/)[^\\.]+'))

for(i in 1:length(excel_files$files)){
  
  assign(excel_files$df_name[i], read_excel(excel_files$files[i]))
  
}

# import csv files

csv_files <- data.frame(files = list.files("data/", pattern='*.csv', full.names = TRUE)) %>% 
  mutate(., df_name = str_extract(files, '(?<=data/)[^\\.]+'))

for(i in 1:length(csv_files$files)){
  
  assign(csv_files$df_name[i], read_csv(csv_files$files[i]))
  
}

# CLEAN DATA -------------------------------------------------------------------------------- 

# drop unnecessary columns in dataframes, could do this for all dataframes in one go but would have to reslist the dataframes and unlist and rename etc. 

# coens_culinaire_reisgids_gmaps <- select(coens_culinaire_reisgids_gmaps, -c("ID", "Start time", "Completion time", "Name", "Email"))

coens_culinaire_reisgids_processed_v2 <- select(coens_culinaire_reisgids_processed_v2, -c("ID", "Start time", "Completion time", "Name", "Email"))

coens_culinaire_reisgids_geocoded <- select(coens_culinaire_reisgids_geocoded, -c("ID", "Start.time", "Completion.time", "Name", "Email"))

# rename columns in dataframes, same comment about listing, unlisting, renaming in terms of doing this simultaneously 

coens_culinaire_reisgids_processed_v2 <- rename(coens_culinaire_reisgids_processed_v2,
                naam = `Naam: \r\n`,
                gerecht = `Dit gerecht zou je echt eens moeten proberen:\r\n`,
                land = `Het komt uit dit land:\r\n`,
                horecagelegenheid = `Horecagelegenheid (naam, adresgegevens en website): \r\n`,
                tip = `Waarom geef ik je deze tip:\r\n`,
                foto_gerecht = `Foto van dit gerecht en evt van het restaurant\r\n`,
                foto_persoon = `Foto van jezelf (optioneel), je mag ook meerdere foto's uploaden, met of zonder Coen erbij. Nb. Denk aan privacy van collega's.\r\n`
)

# coens_culinaire_reisgids_gmaps <- rename(coens_culinaire_reisgids_gmaps,
#                                         naam = `Naam: \r\n`,
#                                         gerecht = `Dit gerecht zou je echt eens moeten proberen:\r\n`,
#                                         land = `Het komt uit dit land:\r\n`,
#                                         horecagelegenheid = `Horecagelegenheid (naam, adresgegevens en website): \r\n`,
#                                         tip = `Waarom geef ik je deze tip:\r\n`,
#                                         foto_gerecht = `Foto van dit gerecht en evt van het restaurant\r\n`,
#                                         foto_persoon = `Foto van jezelf (optioneel), je mag ook meerdere foto's uploaden, met of zonder Coen erbij. Nb. Denk aan privacy van collega's.\r\n`
#)

# merge dataframes to include geocoding and google maps embed


# mostly works, lose the last two rows without map data
forms <- right_join(coens_culinaire_reisgids_raw_v2, coens_culinaire_reisgids_gmaps, 
                   by = c("naam", "gerecht", "land", "horecagelegenheid", "tip", "foto_gerecht", "foto_persoon")) 

# does not work, losing data
### forms <- right_join(forms, coens_culinaire_reisgids_geocoded,
###                  by = c("naam", "gerecht", "land", "horecagelegenheid", "tip", "foto_gerecht", "foto_persoon")) 

# merging with new data frames

forms <- left_join(coens_culinaire_reisgids_processed_v2, coens_culinaire_reisgids_geocoded, 
                    by = c("naam", "gerecht", "land", "horecagelegenheid", "tip", "foto_gerecht", "foto_persoon")) 

# geocoding

google_key <- read_file("C:\\Users\\Moope001\\OneDrive - Universiteit Utrecht\\Documents\\programming\\google_key.txt")

#forms <- read.xlsx("coens_culinaire_reisgids_raw.xlsx", sheetIndex = 1)

coordinates <- geocode(coens_culinaire_reisgids_processed_v2$horecagelegenheid) # more complete

forms <- cbind(coens_culinaire_reisgids_processed_v2, coordinates_2)

# generate URL's that refer to the pages in the book

coens_culinaire_reisgids_processed_v2$name_st <- gsub(" ", "-", tolower(coens_culinaire_reisgids_processed_v2$naam))

coens_culinaire_reisgids_processed_v2$link <- paste0("https://kimbergmans.github.io/culinary-pilgrimage/", coens_culinaire_reisgids_processed_v2$name_st)

# remove double entries



# update file paths to images within dataframe

forms$foto_gerecht <- str_replace_all(forms$foto_gerecht, "https://solisservices-my.sharepoint.com/personal/k_bergmans_uu_nl/Documents/Apps/Microsoft%20Forms/Coens%20culinaire%20reisgids/Vraag/", "images/gerecht/")

forms$foto_persoon <- str_replace_all(forms$foto_persoon, "https://solisservices-my.sharepoint.com/personal/k_bergmans_uu_nl/Documents/Apps/Microsoft%20Forms/Coens%20culinaire%20reisgids/Vraag%202/", "images/people/")

# GENERATE CHAPTERS

chapter_names <- c(forms$naam)
chapter_names <- str_replace_all(chapter_names, " ", "-")

file.copy("scripts/draft_rmd.Rmd", paste0(chapter_names, ".Rmd"))

# EXPORT DATA -------------------------------------------------------------------------------- 

write_xlsx(forms, "data/coens_culinaire_reisgids_processed.xlsx")

# RENDER BOOK -------------------------------------------------------------------------------- 

render_book("index.Rmd")
