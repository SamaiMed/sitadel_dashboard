#library
library(dplyr)
library(tidyr)
library(data.table)
library(lubridate)
library(ggplot2)
library(cowplot)
library(gridExtra )
library(plotly)
#charger les bases des données :
db_1=read.csv2('./data/residentiel/PC_DP_créant_logements_2013_2016.csv',sep=';')
db_2=read.csv2("./data/residentiel/PC_DP_créant_logements_2017_2021.csv",sep=';')
Data=rbind(db_1,db_2)
DataNor=subset(Data,REG=="25")
DataPC=subset(DataNor,Type_DAU=="PC")


DataBase=select(DataPC,REG,DEP,Type_DAU,Etat_DAU,DATE_REELLE_AUTORISATION,CAT_DEM,NATURE_PROJET,UTILISATION,RES_PRINCIP_OU_SECOND,NB_LGT_TOT_CREES)
DataBase$year=year(DataBase$DATE_REELLE_AUTORISATION)
DataBase$mois=month(DataBase$DATE_REELLE_AUTORISATION)

DataBaseAnnee <- DataBase %>%
group_by(year) %>%
  dplyr::summarise(NB_LGT_TOT_CREES=sum(NB_LGT_TOT_CREES))  %>%
  
  ggplot(aes(x=year, y=NB_LGT_TOT_CREES)) +
  geom_histogram() +  scale_x_continuous(breaks = 1:12) +
  expand_limits(y = 0) + theme_bw() + ggtitle("Evolution  nbr de logement crees ")+ ylab("nbr logement cree par annee") +
  xlab("Date en annee")
