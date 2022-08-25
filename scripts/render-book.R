# LOAD PACKAGES -----------------------------------------------------------------------------------

library(tidyverse)
library(bookdown)

# IMPORT DATA -------------------------------------------------------------------------------------------

forms <- read_excel("data/coens_culinaire_reisgids_processed_in_v4.xlsx")

# REMOVE DUPLICATES --------------------------------------------------------------------------------

forms <- forms[!duplicated(forms$naam),]

# GENERATE CHAPTERS --------------------------------------------------------------------------------

chapter_names <- c(forms$naam)
chapter_names <- str_replace_all(chapter_names, " ", "-")

file.copy("scripts/draft_rmd.Rmd", paste0(chapter_names, ".Rmd"))

# RENDER BOOK --------------------------------------------------------------------------------------

render_book("index.Rmd")

# END ----------------------------------------------------------------------------------------------