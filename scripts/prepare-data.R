# LOAD PACKAGES ----------------------------------------------------------------------------------- 

library(bookdown)
library(data.table)
library(ggmap)
library(RgoogleMaps)
library(shiny)
library(leaflet)
library(tidyverse)
library(readxl)

# IMPORT DATA ------------------------------------------------------------------------------------- 

forms <- read_excel("data/coens_culinaire_reisgids_processed_v2.xlsx")

# CLEAN DATA -------------------------------------------------------------------------------- 

# drop unnecessary columns 

forms <- select(forms, -c("ID", "Start time", "Completion time", "Name", "Email"))

# rename columns 

forms <- rename(forms,
                naam = `Naam: \r\n`,
                gerecht = `Dit gerecht zou je echt eens moeten proberen:\r\n`,
                land = `Het komt uit dit land:\r\n`,
                horecagelegenheid = `Horecagelegenheid (naam, adresgegevens en website): \r\n`,
                tip = `Waarom geef ik je deze tip:\r\n`,
                foto_gerecht = `Foto van dit gerecht en evt van het restaurant\r\n`,
                foto_persoon = `Foto van jezelf (optioneel), je mag ook meerdere foto's uploaden, met of zonder Coen erbij. Nb. Denk aan privacy van collega's.\r\n`
                )


# update file paths to images 

forms$foto_gerecht <- str_replace_all(forms$foto_gerecht, "https://solisservices-my.sharepoint.com/personal/k_bergmans_uu_nl/Documents/Apps/Microsoft%20Forms/Coens%20culinaire%20reisgids/Vraag/", "images/gerechten/")
forms$foto_gerecht <- str_replace_all(forms$foto_gerecht, "https://solisservices-my.sharepoint.com/personal/k_bergmans_uu_nl/_layouts/15/Doc.aspx?", "images/gerechten/")
forms$foto_gerecht <- str_remove_all(forms$foto_gerecht, "sourcedoc=%7")
forms$foto_gerecht <- str_replace_all(forms$foto_gerecht, "%20", " ") 

forms$foto_persoon <- str_replace_all(forms$foto_persoon, "https://solisservices-my.sharepoint.com/personal/k_bergmans_uu_nl/Documents/Apps/Microsoft%20Forms/Coens%20culinaire%20reisgids/Vraag%202/", "images/people/")
forms$foto_persoon <- str_replace_all(forms$foto_persoon, "https://solisservices-my.sharepoint.com/personal/k_bergmans_uu_nl/_layouts/15/Doc.aspx?", "images/people/")
forms$foto_persoon <- str_remove_all(forms$foto_persoon, "sourcedoc=%7")
forms$foto_persoon <- str_replace_all(forms$foto_persoon, "%20", " ")

# GEOCODING --------------------------------------------------------------------------------

# google_key <- read_file("path\google_key.txt")
# register google key before proceeding

# map coordinates

coordinates <- geocode(forms$horecagelegenheid)

forms <- cbind(forms, coordinates)

# generate URL's that refer to the pages in the book

forms$name_st <- gsub(" ", "-", tolower(forms$naam))

forms$link <- paste0("https://kimbergmans.github.io/culinary-pilgrimage/", forms$name_st)

# EXPORT DATA -------------------------------------------------------------------------------- 

write_xlsx(forms, "data/coens_culinaire_reisgids_processed_v3.xlsx")

# END ----------------------------------------------------------------------------------------