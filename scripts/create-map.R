# LOAD PACKAGES -----------------------------------------------------------------------------------------

library(data.table)
library(leaflet)
library(readxl)
library(RgoogleMaps)
library(ggmap)
library(shiny)

# IMPORT DATA -------------------------------------------------------------------------------------------

forms <- read_excel("data/coens_culinaire_reisgids_processed_in_v4.xlsx")

# REMOVE DUPLICATES --------------------------------------------------------------------------------

forms <- forms[!duplicated(forms$naam),]

# CREATE MAP --------------------------------------------------------------------------------------------

leaflet(data = forms) %>% setView(lng = 10.95931966568949, lat = 50.1812298717116, zoom = 2) %>%
  addTiles() %>%
  addCircleMarkers(lat = ~lat, lng = ~lon, popup = paste0("<a href='",forms$link,"'>",
                                                          paste0(forms$naam,": ",forms$gerecht),"</a>"), 
                   color = "red", clusterOptions = markerClusterOptions())

# END ---------------------------------------------------------------------------------------------------
