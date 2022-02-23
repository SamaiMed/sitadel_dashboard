#libraries
library(dplyr)
library(tidyr)
library(data.table)
library(lubridate)
library(ggplot2)
library(cowplot)
library(gridExtra )
library(plotly)

#load Data
DataPC=read.csv2("./data/residentiel/PC_DP_créant_logements_2013_2021_Dep25_pc.csv", sep=';')
#
DataPC=select(DataPC,Etat_DAU,
               DATE_REELLE_AUTORISATION,
               CAT_DEM,
               REC_ARCHI,ADR_CODPOST_TER,
               NATURE_PROJET, UTILISATION,RES_PRINCIP_OU_SECOND, TYP_ANNEXE,RESIDENCE_SERVICE)
DataPC$year=year(DataPC$DATE_REELLE_AUTORISATION)
DataPC$mois=month(DataPC$DATE_REELLE_AUTORISATION)
DataPC$jour=day(DataPC$DATE_REELLE_AUTORISATION)

DataPC$moisAnnee=as.Date(ISOdate(year=DataPC$year,month=DataPC$mois , day="1"))                    #format(as.Date(DataPC$DATE_REELLE_AUTORISATION), "%Y-%m")


#DataPC=subset(DataPC,Etat_DAU=='2')#PC autorisé

DataPCAnnee <- DataPC %>%
  group_by(moisAnnee,Etat_DAU) %>%
  dplyr::summarise(counts=length(Etat_DAU))  

DataPCAnnee$Etat_DAU=as.character(DataPCAnnee$Etat_DAU)

fig <- plot_ly(DataPCAnnee, x = ~moisAnnee, y = ~counts, type = 'bar',color=~Etat_DAU)

fig <- fig %>% layout(yaxis = list(title = 'Count'), barmode = 'group')

fig




