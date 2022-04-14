
library(tidyverse)
library(magrittr)
library(rvest)
library(DBI)

source("R/fundamentus_validator.R")


### EXTRACT ###

BASE_URL <- "https://www.ivalor.com.br/empresas/listagem?p="

lista_urls <- purrr::map_chr(1:28, function(.x) paste0(BASE_URL, .x))

data <- 
  parallel::mclapply(lista_urls, function(x) html_table(read_html(x)), mc.cores = 12)


### TRANSFORM ###

df <- bind_rows(data)

df_stocks <- df %>% select("code" = 4) %$% 
  str_replace_all(code, pattern = "\\s+", replacement = ".") %>%
  strsplit(split = ".", fixed = TRUE) %>%
  unlist()
  
df_valid_stocks <- tibble(
  stocks = df_stocks,
  validation = parallel::mclapply(df_stocks, fundamentus_validator, mc.cores = 12)
)

stocks <- df_valid_stocks %>%
  filter(validation == 1) %>%
  pull(stocks)


### LOAD ###

conn <- dbConnect(RSQLite::SQLite(), "data/valuation.db")

dbWriteTable(conn, "b3_stocks", tibble(code = stocks), overwrite = TRUE)

dbDisconnect(conn)
