fundamentus_validator <- function(stock) {
  
  url <- paste0("https://www.fundamentus.com.br/detalhes.php?papel=", stock)
  
  tables <- rvest::read_html(url) |>
    rvest::html_table()
  
  if (length(tables) == 5) {
    
    vol_medio <- pull(tables[[1]][4][5, ]) |> 
      str_replace_all("\\.", "") |>  
      as.double()
    
    if (vol_medio > 0) {
    
    return(1)
    
    } else {
      
      return(0)}
  
  } else {
    
    return(0)
  
  }
}

