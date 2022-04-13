# valuation-analysis

library(tidyverse)

# source("R/ivalor.R")
source("R/fundamentus.R")

# Functions ---

funs <- list(
  # Instead create regex transformation function
  decimal = function(x) as.double(str_replace(x, ",", ".")),
  integer = function(x) as.double(str_replace_all(x, "\\.", "")),
  percent = function(x) as.double(str_replace(str_remove(x, "%"), ",", "."))
)

# Script ---

BASE_URL <- "https://www.fundamentus.com.br/detalhes.php?papel="

b3_stocks <- readRDS(file = "data/validb3stocks.rds")

lista_urls <- purrr::map_chr(
  b3_stocks, function(.x) as.character(paste(BASE_URL, .x, sep = "")))

# df <- purrr::map_df(lista_urls, ~ fundamentus(url = .x)) |> filter(!is.na(valor)) # nolint

df_parallel <-
  parallel::mclapply(lista_urls, fundamentus, mc.cores = 12) |> bind_rows()