# valuation-analysis

library(tidyverse)
library(DBI)

source("R/fundamentus.R")
source("R/transformations.R")

### EXTRACT ###

BASE_URL <- "https://www.fundamentus.com.br/detalhes.php?papel="

conn <- dbConnect(RSQLite::SQLite(), "data/valuation.db")

b3_stocks <- dbReadTable(conn, "b3_stocks") |> pull()

lista_urls <- purrr::map_chr(
  b3_stocks, function(.x) as.character(paste(BASE_URL, .x, sep = "")))

# df <- purrr::map_df(sample(lista_urls, 10), ~ fundamentus(url = .x)) |> filter(!is.na(preco))

df_parallel <- parallel::mclapply(lista_urls, fundamentus, mc.cores = 12) |> 
  bind_rows() |> drop_na(preco)

### TRANSFROM ###

### LOAD ###

dbDisconnect(conn)
