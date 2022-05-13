library(dplyr)
library(glue)
library(here)
library(httr)
library(lubridate)
library(readr)
library(rvest)
library(stringr)
library(xml2)

source(here("R", "utils.R"))

url <- "https://meteo.armada.mil.uy/{tide_station_url}.php"

get_tide_data <- function(tide_station = "La Paloma",
                          timeout = 60,
                          write = TRUE) {
  message(glue(
    "Descargando datos de nivel del mar de la estación '{tide_station}'."
  ))
  
  if (tide_station == "La Paloma") {
    tide_station_url <- "Est4Armada"
  } else if (tide_station == "Punta Lobos") {
    tide_station_url <- "Est5Armada"
  } else {
    stop(
      "Nombre de estación mareográfica inválida. Las opciones posibles son: 'La Paloma', o 'Punta Lobos'."
    )
  }
  
  sohma_tide_html <- POST(
    url = glue(url),
    body = "48h=48h&oculto=",
    content_type("application/x-www-form-urlencoded"),
    httr::timeout(timeout)
  )
  
  sohma_tide_table <-
    xml2::read_html(x = sohma_tide_html) %>%
    rvest::html_node("#tableDatos") %>%
    rvest::html_table(
      x = .,
      header = TRUE,
      trim = TRUE,
      dec = ".",
      fill = TRUE
    ) %>%
    rename(any_of(c(
      fecha = "Fecha",
      temperatura = "T (°C)",
      marea = "M (m)"
    ))) %>%
    mutate(fecha = dmy_hms(fecha, tz = "America/Montevideo"))
  
  date_from <- min(sohma_tide_table$fecha)
  date_to <- max(sohma_tide_table$fecha)
  message(glue("Observaciones desde {date_from} a {date_to}."))
  
  # Write tide data
  if (write) {
    if (!dir.exists("output")) {
      dir.create("output")
    }
    
    tide_station <-
      str_replace_all(str_to_lower(tide_station), " ", "_")
    date_from <- format_datetime(date_from)
    date_to <- format_datetime(date_to)
    file_name <-
      glue("tide_{tide_station}_{date_from}_{date_to}.csv")
    message(glue("Guardando datos en archivo {file_name}."))
    readr::write_csv(x = sohma_tide_table, file = here("output", file_name))
  }
  
  return(sohma_tide_table)
  
}


# Download data for different weather stations
for (tide_station in c("La Paloma", "Punta Lobos")) {
  get_tide_data(tide_station = tide_station)
}
