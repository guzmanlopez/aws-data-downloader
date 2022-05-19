library(dplyr)
library(here)
library(stringr)
library(tsibble)

source(here("R", "utils.R"))

process_all_files <- function(write = TRUE) {
  message("Procesando todos los archivos descargados...")
  filenames <- list.files(path = here("output"), pattern = "*.csv")
  
  df_historical <-
    purrr::map_df(
      here("output", filenames),
      readr::read_csv,
      id = "estacion",
      progress = TRUE,
      show_col_types = FALSE
    ) %>%
    mutate(estacion =
             str_trim(
               str_replace_all(
                 string = estacion,
                 pattern = str_glue("({here('output')}/)|([0-9]+|[_]+)|(.csv)"),
                 replacement = " "
               )
             )) %>%
    distinct() %>%
    mutate(fecha = lubridate::floor_date(fecha, "5 mins")) %>%
    as_tsibble(key = estacion,
               index = fecha,
               regular = TRUE)
  
  date_from <- min(df_historical$fecha)
  date_to <- max(df_historical$fecha)
  message(str_glue("Observaciones desde {date_from} a {date_to}."))
  
  # Write processed data
  if (write) {
    if (!dir.exists("output/aggregated")) {
      dir.create("output/aggregated")
    }
    
    date_from <- format_datetime(date_from)
    date_to <- format_datetime(date_to)
    file_name <- "historical.csv"
    message(str_glue("Guardando datos en archivo '{file_name}'."))
    readr::write_csv(x = df_historical,
                     file = here("output", "aggregated", file_name))
  }
  
  # Check missing data by station
  message("Datos faltantes:\n")
  df_historical %>%
    group_split(estacion) %>%
    purrr::map(., ~ count_gaps(.x, .full = TRUE)) %>%
    purrr::set_names(unique(df_historical$estacion)) %>%
    print()
  
  return(df_historical)
  
}

# Process all raw data
process_all_files(write = TRUE)
