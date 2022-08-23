# LOAD PACKAGES -------------------------------------------------------------------------------- 

library(data.table)
library(leaflet)
library(tidyverse)
library(bookdown)

# IMPORT DATA -------------------------------------------------------------------------------- 

forms <- read_excel("data/coens_culinaire_reisgids_raw.xlsx")

# CLEAN DATA -------------------------------------------------------------------------------- 

# drop unnecessary columns

forms <- select(forms, -c("Start time", "Completion time", "Email"))

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

# EXPORT DATA -------------------------------------------------------------------------------- 

write_xlsx(forms, "data/coens_culinaire_reisgids_processed.xlsx")

# RENDER BOOK -------------------------------------------------------------------------------- 

render_book("index.Rmd")