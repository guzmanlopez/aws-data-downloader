

format_datetime <- function(datetime) {
  datetime <-
    datetime %>%
    stringr::str_replace_all(" -03", "") %>%
    stringr::str_replace_all("-", "") %>%
    stringr::str_replace_all(":", "") %>%
    stringr::str_replace_all(" ", "")
  
  return(datetime)
  
}
