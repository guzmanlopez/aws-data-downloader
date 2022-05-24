[![AWS data downloader](https://github.com/guzmanlopez/aws-data-downloader/actions/workflows/main.yaml/badge.svg?branch=main)](https://github.com/guzmanlopez/aws-data-downloader/actions/workflows/main.yaml) [![pages-build-deployment](https://github.com/guzmanlopez/aws-data-downloader/actions/workflows/pages/pages-build-deployment/badge.svg?branch=main)](https://github.com/guzmanlopez/aws-data-downloader/actions/workflows/pages/pages-build-deployment)

# Automatic Weather Station data downloader

El objetivo de este código es descargar periódicamente (24 horas) los datos meteorológicos y mareográficos generados por el Servicio de Oceanografía, Hidrografía y Meteorología de la Armada ([SOHMA](https://sohma.armada.mil.uy/), Uruguay) para su respaldo y fácil acceso por parte de la comunidad.

## Panel interactivo

Para ver todos los datos en figuras interactivas por estaciones meteorológicas y mareográficas ingresar al [Panel interactivo](https://guzmanlopez.github.io/aws-data-downloader/).
## Descarga de los datos

A continuación se detallan tres opciones de cómo descargarse todos los datos de este repositorio descargados hasta el momento:

### Opción 1

Utilizando la página web estática generada por este sitio: 

- Ingresar a [Panel interactivo - Descargar datos](https://guzmanlopez.github.io/aws-data-downloader/#descargar-datos).
- Luego elegir formato CSV (texto plano separado por comas) o Excel haciendo clic en las opciones que se presentan arriba a la izquierda. 

### Opción 2

Descargarse el archivo comprimido de todo el repositorio desde aquí: [main.zip](https://github.com/guzmanlopez/aws-data-downloader/archive/refs/heads/main.zip)

### Opción 3

Utilizando la terminal, clonar el repositorio:

```{sh}
# Utilizando HTTPS
git clone https://github.com/guzmanlopez/aws-data-downloader.git

# O utilizando SSH
git clone git@github.com:guzmanlopez/aws-data-downloader.git
```

Para actualizar los últimos datos:

```{sh}
# En el directorio del repositorio previamente clonado:
git pull
```

