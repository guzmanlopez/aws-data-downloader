library(dplyr)
library(here)
library(httr)
library(lubridate)
library(readr)
library(rvest)
library(stringr)
library(xml2)

source(here("R", "utils.R"))

url <- "https://meteo.armada.mil.uy/{weather_station_url}.php"

get_meteo_data_from_aws <- function(weather_station = "La Paloma",
                                    timeout = 60,
                                    write = TRUE) {
  message(str_glue(
    "Descargando datos meteorológicos de la estación '{weather_station}'."
  ))
  
  if (weather_station == "Punta Brava") {
    weather_station_url <- "index"
  } else if (weather_station == "La Paloma") {
    weather_station_url <- "Est2Armada"
  } else if (weather_station == "Colonia") {
    weather_station_url <- "Est3Armada"
  } else {
    stop(
      "Nombre de estación meteorológica inválida. Las opciones posibles son: 'Punta Brava', 'La Paloma', o 'Colonia'."
    )
  }
  
  sohma_meteo_html <- POST(
    url = str_glue(url),
    body = "48h=48h&oculto=&Temperatura=Temperatura&Humedad=Humedad",
    content_type("application/x-www-form-urlencoded"),
    httr::timeout(timeout)
  )
  
  sohma_meteo_table <-
    xml2::read_html(x = sohma_meteo_html) %>%
    rvest::html_node("#tableDatos") %>%
    rvest::html_table(
      x = .,
      header = TRUE,
      trim = TRUE,
      dec = ".",
      fill = TRUE
    ) %>%
    rename(any_of(
      c(
        fecha = "Fecha",
        temperatura = "T (°C)",
        humedad = "H (%)",
        presion = "P (hPa)",
        vel_viento = "WS (kts)",
        dir_viento = "DV (°)"
      )
    )) %>%
    select(-`DV (img)`) %>%
    mutate(dir_viento_2 = str_extract(dir_viento, "[A-Z]+")) %>%
    mutate(dir_viento = str_extract(dir_viento, "[0-9]+")) %>%
    mutate(fecha = dmy_hms(fecha, tz = "America/Montevideo"))
  
  date_from <- min(sohma_meteo_table$fecha)
  date_to <- max(sohma_meteo_table$fecha)
  message(str_glue("Observaciones desde {date_from} a {date_to}."))
  
  # Write meteo data
  if (write) {
    if (!dir.exists("output")) {
      dir.create("output")
    }
    
    weather_station <-
      str_replace_all(str_to_lower(weather_station), " ", "_")
    date_from <- format_datetime(date_from)
    date_to <- format_datetime(date_to)
    file_name <-
      str_glue("meteo_{weather_station}_{date_from}_{date_to}.csv")
    message(str_glue("Guardando datos en archivo '{file_name}'."))
    readr::write_csv(x = sohma_meteo_table, file = here("output", file_name))
  }
  
  return(sohma_meteo_table)
  
}


# Download data for different weather stations
for (weather_station in c("La Paloma", "Punta Brava", "Colonia")) {
  get_meteo_data_from_aws(weather_station = weather_station)
}
