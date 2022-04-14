decimal <- function(x) {
  if (stringr::str_detect(x, "-")) {
    return(NA)
    
  } else {
    return(as.double(stringr::str_replace(x, pattern = ",", replacement = ".")))
    
  }
}

integer <- function(x) {
  if (stringr::str_detect(x, "-")) {
    return(NA)
    
  } else {
    return(as.double(str_replace_all(x, pattern =  "\\.", replacement = "")))
    
  }
}


percent <- function(x) {
  if (stringr::str_detect(x, "-")) {
    return(NA)
    
  } else {
    return(as.double(str_replace(str_remove(x, "%"), pattern = ",", replacement = ".")))
    
  }
}


