
library(tidyverse)
library(magrittr)
library(rvest)

source("R/fundamentus_validator.R")

lista_urls <-
  purrr::map_chr(1:28, function(.x) {
    glue::glue("https://www.ivalor.com.br/empresas/listagem?p={.x}")
  })

data <- purrr::map_df(lista_urls, function(.x) read_html(.x) |> html_table())

data_stocks <- data %>% select("code" = 4) %$% 
  str_replace_all(code, pattern = "\\s+", replacement = ".") %>%
  strsplit(split = ".", fixed = TRUE) %>%
  unlist()
  
data_valid_stocks <- tibble(
  stocks = data_stocks,
  validation = map(data_stocks, fundamentus_validator)
)

stocks <- data_valid_stocks %>%
  filter(validation == TRUE) %>%
  pull(stocks)

write_rds(stocks, file = "data/validb3stocks.rds")

# 337.548 (5 minutes) sec elapsed 
