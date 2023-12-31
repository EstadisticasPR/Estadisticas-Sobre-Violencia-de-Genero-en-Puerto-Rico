########################################
#### Cargar bibliotecas necesarias #####
########################################
packages <- c(
  "tidyverse",
  "readxl",
  "kableExtra",
  "zoo",
  "here",
  "viridis",
  "shinythemes",
  "plotly",
  "DT"
)

for (package in packages) {
  library(package, character.only = TRUE)
}

##################################################################
##### convert_mixed_columns se usa para manejar missing data #####
##################################################################
# funcion para convertir columna con varios tipos de datos a numerico
convert_mixed_columns <- function(data) {
  mixed_columns <- sapply(data, function(col) any(is.character(col) & !is.na(as.numeric(col))))
  mixed_columns_names <- names(mixed_columns)[mixed_columns]
  
  for (col in mixed_columns_names) {
    data[[col]] <- ifelse(data[[col]] == "N/A", NA, as.character(data[[col]]))
    data[[col]] <- as.numeric(data[[col]])
  }
  
  return(data)
}

##################################################################################
#### Procesamiento de datos del Sistema de Notificacion de Muertes Violentas #####
##################################################################################
# path para Sistema_de_Notificacion_de_Muertes_Violentas
snmv <- here("data", "Sistema_de_Notificacion_de_Muertes_Violentas", "/")

# importar los datos de homicidios por grupo de edad; homiEdad
homiEdad <- read_excel(paste0(snmv, "svmvhomiEdad.xlsx")) %>%
  select(-Total) %>%
  filter(!grepl("Total", `Grupo de edad`) & `Grupo de edad` != "Desconocido") %>%
  pivot_longer(!`Grupo de edad`, names_to = "año", values_to = "casos") %>%
  rename(edad = `Grupo de edad`) %>%
  mutate(
    edad = factor(edad, levels = unique(edad)),
    año = factor(año)
  )

# Definir una paleta de colores personalizada
colores_homiEdad <- setNames(
  unique(homiEdad$edad), 
  scales::hue_pal()(length(unique(homiEdad$edad)))
)

#############################################################
#### Procesamiento de datos del Departamento de Familia #####
#############################################################
# path para los datos del Departamento de Familia
dfam <- here("data", "Departamento_de_Familia", "/")

# importar los datos de maltratos; dfMalt
# importando datos del 2018
dfMalt2018 <- read_excel(paste0(dfam, "dfMalt2018.xlsx")) %>%
  mutate(Año = "2018")

# importando datos del 2019
dfMalt2019 <- read_excel(paste0(dfam, "dfMalt2019.xlsx")) %>%
  mutate(Año = "2019")

# importando datos del 2020
dfMalt2020 <- read_excel(paste0(dfam, "dfMalt2020.xlsx")) %>%
  mutate(Año = "2020")

# importando datos del 2021
dfMalt2021 <- read_excel(paste0(dfam, "dfMalt2021.xlsx")) %>%
  mutate(Año = "2021")

# importando datos del 2022
dfMalt2022 <- read_excel(paste0(dfam, "dfMalt2022.xlsx")) %>%
  mutate(Año = "2022")

dfMalt <- dfMalt2018 %>%
  full_join(dfMalt2019) %>%
  full_join(dfMalt2020) %>%
  full_join(dfMalt2021) %>%
  full_join(dfMalt2022) %>%
  rename(
    Masculino = `Cantidad Masculino`,
    Femenino = `Cantidad Femenino`
  ) %>%
  pivot_longer(
    !c(`Tipo de Maltrato`, Año),
    names_to = "Sexo",
    values_to = "Casos"
  ) %>%
  mutate(
    `Tipo de Maltrato` = factor(`Tipo de Maltrato`),
    Año = factor(Año),
    Sexo = factor(Sexo)
  ) %>%
  rename(
     Maltrato = `Tipo de Maltrato`
  )
########################################
##### Actualizaciones de los Datos #####
########################################
# Fecha actualizacion de los datos de violencia domestica
actualizacion_policiaA <- "06/09/2023"

# Fecha cuando se actualizan los datos de desaparecidas
actualizacion_policiaB <- "05/03/2023"

# Fecha actualizacion delitos Ley 54
actualizacion_justiciaA <- "06/09/2023"

# Fecha actualizacion registro de personas convictas
actualizacion_justiciaB <- "06/09/2023"

# Fecha actualizacion feminicidios
actualizacion_opmA <- "05/17/2022"

# Fecha actualizacion resto de los datos de OPM
actualizacion_opmB <- "04/20/2023"

# Fecha actualizacion datos del SNMV
actualizacion_snmvA <- "12/23/2021"

# Fecha actualizacion tasas ajustadas del SNMV
actualizacion_snmvB <- "06/30/2022"

# Fecha actualizacion datos de Correcion
actualizacion_correcion <- "04/03/2023"

# Fecha actualizacion datos de Vivienda
actualizacion_vivienda <- "07/19/2023"

# Fecha actualizacion datos del Observatorio
actualizacion_observatorio <- ""

# Fecha actualizacion datos del Dept de Trabajo
actualizacion_trabajo <- "07/12/2021"

# Fecha actualizacion datos Dept Familia
actualizacion_familia <- "06/09/2021"

# Fecha actualizacion Ordenes de Proteccion
actualizacion_tribunalesA <- "02/21/2023"

# Fecha actualizacion Movimiento Casos
actualizacion_tribunalesB <- "02/21/2023"
