fundamentus_validator <- function(stock) {
  
  url <- paste0("https://www.fundamentus.com.br/detalhes.php?papel=", stock)
  
  html_page <- rvest::read_html(url)
  
  tables <- rvest::html_table(html_page)
  
  if (length(tables) == 5) {
    
    return(TRUE)
    
  } else {
    
    return(FALSE)
  
  }
}

