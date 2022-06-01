format_datetime <- function(datetime) {
  datetime <-
    datetime %>%
    stringr::str_replace_all(" -03", "") %>%
    stringr::str_replace_all("-", "") %>%
    stringr::str_replace_all(":", "") %>%
    stringr::str_replace_all(" ", "")
  
  return(datetime)
  
}


create_station_chart <-
  function(data,
           station = c("meteo la paloma", "tide la paloma")) {
    meteo_station = station[which(!is.na(stringr::str_match(station, "meteo")))]
    tide_station = station[which(!is.na(stringr::str_match(station, "tide")))]
    
    if (length(meteo_station) == 1) {
      meteo <- data[[meteo_station]]
    } else {
      meteo <- data.frame(fecha = NA, marea = NA)
    }
    
    if (length(tide_station) == 1) {
      tide <- data[[tide_station]]
    } else {
      tide <- data.frame(fecha = as.Date(NA), marea = NA)
    }
    
    highchart(type = "stock", theme = hc_theme_ggplot2()) %>%
      hc_add_series(
        data = meteo %>% select(fecha, temperatura),
        hcaes(x = datetime_to_timestamp(fecha), y = temperatura),
        type = "line",
        showInLegend = FALSE,
        color = "#f51720",
        name = "Temperatura del aire (°C)",
        yAxis = 0
      )  %>%
      hc_add_yAxis(
        nid = 1L,
        title = list(text = "Temperatura del aire (°C)"),
        relative = 1
      ) %>%
      hc_add_series(
        data = meteo %>% select(fecha, humedad),
        hcaes(x = datetime_to_timestamp(fecha), y = humedad),
        type = "line",
        showInLegend = FALSE,
        color = "#2ff3e0",
        name = "Humedad (%)",
        yAxis = 1
      )  %>%
      hc_add_yAxis(
        nid = 2L,
        title = list(text = "Humedad (%)"),
        relative = 1
      ) %>%
      hc_add_series(
        data = meteo %>% select(fecha, presion),
        hcaes(x = datetime_to_timestamp(fecha), y = presion),
        type = "line",
        showInLegend = FALSE,
        color = "#f8d210",
        name = "Presión Atmosférica (hPa)",
        yAxis = 2
      )  %>%
      hc_add_yAxis(
        nid = 3L,
        title = list(text = "Presión Atmosférica (hPa)"),
        relative = 1
      ) %>%
      hc_add_series(
        data =
          tide %>%
          select(fecha, marea),
        hcaes(x = datetime_to_timestamp(fecha), y = marea),
        type = "line",
        showInLegend = FALSE,
        color = "#059dc0",
        name = "Nivel del mar (m)",
        yAxis = 3
      ) %>%
      hc_add_yAxis(
        nid = 4L,
        title = list(text = "Nivel del mar (m)"),
        relative = 1
      ) %>%
      hc_xAxis(title = list(text = "Fecha"), type = "datetime") %>%
      hc_rangeSelector(
        verticalAlign = "top",
        selected = 0,
        buttons = list(
          list(
            type = "day",
            count = 1,
            text = "Día",
            title = "Ver un día"
          ),
          list(
            type = "week",
            count = 1,
            text = "Sem.",
            title = "Ver una semana"
          ),
          list(
            type = "month",
            count = 1,
            text = "Mes",
            title = "Ver un mes"
          ),
          list(
            type = "all",
            text = "Todo",
            title = "Ver todos los datos"
          )
        )
      ) %>%
      hc_tooltip(crosshairs = TRUE, valueDecimals = 2) %>%
      hc_credits(
        enabled = TRUE,
        text = "Fuente: Servicio de Oceanografía, Hidrografía y Meteorología de la Armada (SOHMA)",
        href = "https://meteo.armada.mil.uy/",
        style = list(fontSize = "10px")
      ) %>%
      hc_boost(enabled = TRUE)
  }


create_wind_chart <-
  function(data, station = "meteo la paloma") {
    meteo <- data[[station]]
    
    highchart(type = "stock", theme = hc_theme_ggplot2()) %>%
      hc_add_series(
        data = meteo %>% select(fecha, vel_viento, dir_viento),
        hcaes(
          x = datetime_to_timestamp(fecha),
          y = vel_viento,
          length = vel_viento,
          direction = dir_viento
        ),
        type = "vector",
        showInLegend = FALSE,
        color = "#4c5270",
        name = "Velocidad (kn) y dirección del viento (°)",
        yAxis = 0
      ) %>%
      hc_add_yAxis(
        nid = 1L,
        title = list(text = "Velocidad (kn) y dirección del viento (°)"),
        relative = 1
      ) %>%
      hc_xAxis(title = list(text = "Fecha"), type = "datetime") %>%
      hc_rangeSelector(
        verticalAlign = "top",
        selected = 0,
        buttons = list(
          list(
            type = "day",
            count = 1,
            text = "Día",
            title = "Ver un día"
          ),
          list(
            type = "week",
            count = 1,
            text = "Sem.",
            title = "Ver una semana"
          ),
          list(
            type = "month",
            count = 1,
            text = "Mes",
            title = "Ver un mes"
          ),
          list(
            type = "all",
            text = "Todo",
            title = "Ver todos los datos"
          )
        )
      ) %>%
      hc_credits(
        enabled = TRUE,
        text = "Fuente: Servicio de Oceanografía, Hidrografía y Meteorología de la Armada (SOHMA)",
        href = "https://meteo.armada.mil.uy/",
        style = list(fontSize = "10px")
      ) %>%
      hc_boost(enabled = TRUE)
    
  }
