fundamentus <- function(url) {
  
  html_page <- rvest::read_html(url)
  
  tables <- rvest::html_table(html_page)
  
  vol_medio <- funs$integer(tables[[1]][4][5,])
  
  if (length(tables) == 5 &  vol_medio > 0) {
    
    message(str_remove(url, pattern = "..*?papel="), ": OK")
    
    lista <- list(
      codigo = as.character(tables[[1]][2][1,]),
      valor = as.double(str_replace(tables[[1]][4][1,], ",", "."))
    )
    
    df <- as_tibble(lista)
    
    return(df)
    
  } else {
    
    lista <- list(
      codigo = str_remove(string = url, pattern = "..*?papel="), valor = NA)
    
    return(lista)
    
  }
}