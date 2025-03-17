library(arrow)
library(dplyr)
library(ggplot2)
library(tidyverse)

df_paso <- read_parquet("ResultadosElectorales_PASO_2023.parquet")
View(df_paso)
colnames(df_paso)

df_generales <- read_parquet("ResultadosElectorales_1v.parquet")
View(df_generales)
colnames(df_generales)

df_ballotage <- read_parquet("ResultadosElectorales_2023_SegundaVuelta.parquet")
View(df_ballotage)
colnames(df_ballotage)

#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#PASO

#Cantidad de votos por tipo de voto en las PASO:
tipos_de_votos_paso <- df_paso[df_paso$cargo_id==1 & df_paso$votos_tipo %in% c("POSITIVO", "EN BLANCO", "NULO", "IMPUGNADO", "COMANDO", "RECURRIDO"),]

tipos_de_votos_paso_sum <- aggregate(votos_cantidad~votos_tipo, data=tipos_de_votos_paso, sum)

tipos_de_votos_paso_sum$porcentaje <- (tipos_de_votos_paso_sum$votos_cantidad/sum(tipos_de_votos_paso_sum$votos_cantidad))*100

ggplot(tipos_de_votos_paso_sum, aes(x=votos_tipo, y=votos_cantidad, fill=votos_tipo)) +
  geom_bar(stat="identity", width = 0.5) +
  scale_y_continuous(labels=scales::comma_format(scale=1e-6, suffix="M")) +
  geom_text(aes(label=votos_cantidad), vjust=-0.5, size=3) +
  labs(title="Cantidad de votos por tipo de voto en las PASO",
       x="Tipo de voto",
       y="Cantidad de votos") +
  theme_minimal()

#Agrupaciones que hayan superado las elecciones PASO presidenciales:
top5_agrupaciones_paso <- df_paso %>%
  filter(cargo_id==1) %>%
  group_by(agrupacion_nombre) %>%
  summarise(total_votos = sum(votos_cantidad, na.rm=TRUE)) %>%
  filter(!is.na(agrupacion_nombre)) %>%
  top_n(5, total_votos)

top5_agrupaciones_paso <- top5_agrupaciones_paso[order(-top5_agrupaciones_paso$total_votos),]

top5_agrupaciones_paso$nombres_simplificados <- c("LLA", "JxC", "UP", "HACEMOS", "FIT")

top5_agrupaciones_paso$porcentaje <- (top5_agrupaciones_paso$total_votos/sum(top5_agrupaciones_paso$total_votos))*100

colores_agrupaciones_paso <- c("LLA"="purple", "JxC"="yellow", "UP"="lightblue", "HACEMOS"="blue", "FIT"="red")

ggplot(top5_agrupaciones_paso, aes(x = reorder(nombres_simplificados, -total_votos), y=total_votos, fill = nombres_simplificados)) +
  geom_bar(stat="identity") +
  labs(title="Agrupaciones que superaron las PASO", x="Agrupación", y="Total de Votos") +
  scale_y_continuous(labels=scales::unit_format(unit="M", scale=1e-6)) +
  scale_fill_manual(values=colores_agrupaciones_paso) +
  geom_text(aes(label=total_votos), vjust=-0.5, size=3) +
  geom_text(aes(label=paste(round(porcentaje, 1), "%")), 
            position=position_stack(vjust = 0.5), 
            size=3)

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#GENERALES

#Cantidad de votos por tipo de voto en las Generales:
tipos_de_votos_generales <- df_generales[df_generales$cargo_id==1 & df_generales$votos_tipo %in% c("POSITIVO", "EN BLANCO", "NULO", "IMPUGNADO", "COMANDO", "RECURRIDO"),]

tipos_de_votos_generales_sum <- aggregate(votos_cantidad~votos_tipo, data=tipos_de_votos_generales, sum)

tipos_de_votos_generales_sum$porcentaje <- (tipos_de_votos_generales_sum$votos_cantidad/sum(tipos_de_votos_generales_sum$votos_cantidad))*100

ggplot(tipos_de_votos_generales_sum, aes(x=votos_tipo, y=votos_cantidad, fill=votos_tipo)) +
  geom_bar(stat="identity", width = 0.5) +
  scale_y_continuous(labels=scales::comma_format(scale=1e-6, suffix="M")) +
  geom_text(aes(label=votos_cantidad), vjust=-0.5, size=3) +
  labs(title="Cantidad de votos por tipo de voto en las Generales",
       x="Tipo de voto",
       y="Cantidad de votos") +
  theme_minimal()

#¿Cómo salieron las elecciones generales para presidente dentro de las 5 agrupaciones que superaron
#las PASO?
agrupaciones_generales <- df_generales %>%
  filter(cargo_id==1) %>%
  group_by(agrupacion_nombre) %>%
  summarise(total_votos=sum(votos_cantidad, na.rm=TRUE)) %>%
  filter(!is.na(agrupacion_nombre)) %>%
  top_n(5, total_votos)

agrupaciones_generales <- agrupaciones_generales[order(-agrupaciones_generales$total_votos),]

agrupaciones_generales$nombres_simplificados <- c("UP", "LLA", "JxC", "HACEMOS", "FIT")

agrupaciones_generales$porcentaje <- (agrupaciones_generales$total_votos/sum(agrupaciones_generales$total_votos))*100

colores_agrupaciones_generales <- c("UP"="lightblue", "LLA"="purple", "JxC"="yellow", "HACEMOS"="blue", "FIT"="red")

ggplot(agrupaciones_generales, aes(x = reorder(nombres_simplificados, -total_votos), y=total_votos, fill = nombres_simplificados)) +
  geom_bar(stat="identity") +
  labs(title="Agrupaciones en las Generales para Persidente", x="Agrupación", y="Total de Votos") +
  scale_y_continuous(labels=scales::unit_format(unit="M", scale=1e-6)) +
  scale_fill_manual(values=colores_agrupaciones_generales) +
  geom_text(aes(label=total_votos), vjust=-0.5, size=3) +
  geom_text(aes(label=paste(round(porcentaje, 1), "%")), 
            position=position_stack(vjust = 0.5), 
            size=3) 

#----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#BALLOTAGE

#Cantidad de votos por tipo de voto en el Ballotage:
tipos_de_votos_ballotage <- df_ballotage[df_ballotage$cargo_id==1 & df_ballotage$votos_tipo %in% c("POSITIVO", "EN BLANCO", "NULO", "IMPUGNADO", "COMANDO", "RECURRIDO"),]

tipos_de_votos_ballotage_sum <- aggregate(votos_cantidad~votos_tipo, data=tipos_de_votos_ballotage, sum)

tipos_de_votos_ballotage_sum$porcentaje <- (tipos_de_votos_ballotage_sum$votos_cantidad/sum(tipos_de_votos_ballotage_sum$votos_cantidad))*100

ggplot(tipos_de_votos_ballotage_sum, aes(x=votos_tipo, y=votos_cantidad, fill=votos_tipo)) +
  geom_bar(stat="identity", width = 0.5) +
  scale_y_continuous(labels=scales::comma_format(scale=1e-6, suffix="M")) +
  geom_text(aes(label=votos_cantidad), vjust=-0.5, size=3) +
  labs(title="Cantidad de votos por tipo de voto en el Ballotage",
       x="Tipo de voto",
       y="Cantidad de votos") +
  theme_minimal()

#¿Cómo salió el Ballotage para presidente con 2 las agrupaciones que llegaron?
agrupaciones_ballotage <- df_ballotage %>%
  filter(cargo_id==1) %>%
  group_by(agrupacion_nombre) %>%
  summarise(total_votos=sum(votos_cantidad, na.rm=TRUE)) %>%
  filter(!is.na(agrupacion_nombre)) %>%
  top_n(5, total_votos)

agrupaciones_ballotage <- agrupaciones_ballotage[order(-agrupaciones_ballotage$total_votos),]

agrupaciones_ballotage$nombres_simplificados <- c("LLA", "UP")

agrupaciones_ballotage$porcentaje <- (agrupaciones_ballotage$total_votos/sum(agrupaciones_ballotage$total_votos))*100

colores_agrupaciones_ballotage <- c("LLA"="purple", "UP"="lightblue")

ggplot(agrupaciones_ballotage, aes(x = reorder(nombres_simplificados, -total_votos), y=total_votos, fill = nombres_simplificados)) +
  geom_bar(stat="identity") +
  labs(title="Agrupaciones en el Ballotage para Persidente", x="Agrupación", y="Total de Votos") +
  scale_y_continuous(labels=scales::unit_format(unit="M", scale=1e-6)) +
  scale_fill_manual(values=colores_agrupaciones_generales) +
  geom_text(aes(label=total_votos), vjust=-0.5, size=3) +
  geom_text(aes(label=paste(round(porcentaje, 1), "%")), 
            position=position_stack(vjust = 0.5), 
            size=3) 

#---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Gráfico general
df_paso_filtrado <- df_paso %>% filter(cargo_id == 1)
df_generales_filtrado <- df_generales %>% filter(cargo_id == 1)
df_ballotage_filtrado <- df_ballotage %>% filter(cargo_id == 1)

total_votos_paso <- sum(df_paso_filtered$votos_cantidad)
total_votos_generales <- sum(df_generales_filtered$votos_cantidad)
total_votos_ballotage <- sum(df_ballotage_filtered$votos_cantidad)

df_grafico <- data.frame(
  Eleccion = c("PASO", "Generales", "Ballotage"),
  Total_Votos = c(total_votos_paso, total_votos_generales, total_votos_ballotage)
)

ggplot(df_grafico, aes(x = reorder(Eleccion, -Total_Votos), y = Total_Votos, fill = Eleccion)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = Total_Votos), vjust = -0.5, size = 3) + 
  labs(title = "Cantidades de Votos por Elección",
       x = "Elección",
       y = "Total de Votos (en millones)") +
  scale_y_continuous(labels = scales::comma_format(scale = 1e-6, suffix = 'M')) +
  theme_minimal()
