# valuation-analysis // main.R

setwd("~/Projects/R/valuation-analysis/")

library(tidyverse)

source("R/fundamentus_scraper.R")
source("R/transformations.R")

### EXTRACT ###

BASE_URL <- "https://www.fundamentus.com.br/detalhes.php?papel="

conn <- DBI::dbConnect(RSQLite::SQLite(), "data/valuation.db")

b3_stocks <- DBI::dbReadTable(conn, "b3_stocks") |> pull()

b3_stocks_url <- purrr::map_chr(b3_stocks, function(.x)
  as.character(paste(BASE_URL, .x, sep = "")))

df_parallel <- parallel::mclapply(b3_stocks_url, fundamentus_scraper, mc.cores = 6)

### TRANSFROM ###

df <- bind_rows(df_parallel)

### LOAD ###

DBI::dbWriteTable(conn, "tb_valuation_index", df, overwrite = TRUE)

DBI::dbDisconnect(conn)
