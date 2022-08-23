### leaflet example code for Coen's present ###

library(data.table)
library(leaflet)
library(xlsx)
library(RgoogleMaps)
library(ggmap)
library(shiny)

setwd("C:\\Users\\Schal107\\Documents\\UBU\\Coen_present")

### These are all the steps, but you can start from the geocoded csv: ###

#forms <- read.xlsx("coens_culinaire_reisgids_raw.xlsx", sheetIndex = 1)

#google_key <- fread("C:\\Users\\Schal107\\Documents\\UBU\\Team DH\\Delpher\\google_key.txt")

#forms <- read.xlsx("coens_culinaire_reisgids_raw.xlsx", sheetIndex = 1)

#coordinates <- geocode(forms$Horecagelegenheid..naam..adresgegevens.en.website....)

# remove double entries

#forms <- forms[-12, ]

# generate URL's that refer to the pages in the book

#forms$name_st <- gsub(" ", "-", tolower(forms$Name))

#forms$link <- paste0("https://kimbergmans.github.io/culinary-pilgrimage/", forms$name_st)

## add Germany coordinates for Sandra's entry

#setDT(forms)
#forms[is.na(lon), lon := 10,271483 ]
#forms[is.na(lat), lat := 51,095123 ]

# save geocoded file with URLS:

#fwrite(forms, "Coens_reisgids_full_geocoded.csv")

### START HERE IF YOU ONLY WANT TO GENERATE THE MAP: ###

forms <- fread("Coens_reisgids_full_geocoded.csv")

### we can add historical world maps if we like, like this, and then add the url inside addTiles: ###

#url <- ("https://maps.georeferencer.com/georeferences/c97256c1-26e3-5101-8282-384bff337213/2020-01-28T20:58:47.531031Z/map/{z}/{x}/{y}.png?key=ebGMmpORFAU1M65ypiIz")

leaflet(data = forms) %>% setView(lng = 10.95931966568949, lat = 50.1812298717116, zoom = 2) %>%
  addTiles() %>%
  addCircleMarkers(lat = ~lat, lng = ~lon, popup = paste0("<a href='",forms$link,"'>",
                                                          paste0(forms$Name,": ",forms$Dit.gerecht.zou.je.echt.eens.moeten.proberen..),"</a>"), 
                   color = "red", clusterOptions = markerClusterOptions())



