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
#filtrer base de donnee
DataPC=select(DataPC,Etat_DAU,
              DATE_REELLE_AUTORISATION,
              CAT_DEM,
              REC_ARCHI,ADR_CODPOST_TER,
              NATURE_PROJET, UTILISATION,RES_PRINCIP_OU_SECOND, TYP_ANNEXE,RESIDENCE_SERVICE)
DataPC$year=year(DataPC$DATE_REELLE_AUTORISATION)
DataPC$mois=month(DataPC$DATE_REELLE_AUTORISATION)
DataPC$jour=day(DataPC$DATE_REELLE_AUTORISATION)
DataPC$moisAnnee=as.Date(ISOdate(year=DataPC$year,month=DataPC$mois , day="1"))  

DataPC$count=1

DataPC <- DataPC %>%
  group_by(moisAnnee,Etat_DAU,NATURE_PROJET) %>%
  dplyr::summarise(counts=sum(count)) 


DataPC$moisAnnee=as.character(DataPC$moisAnnee)
DataPC$Etat_DAU[DataPC$Etat_DAU==2] = "PCAutorise"
DataPC$Etat_DAU[DataPC$Etat_DAU==4] = "PCAnnule"
DataPC$Etat_DAU[DataPC$Etat_DAU==5] = "PCCommence"
DataPC$Etat_DAU[DataPC$Etat_DAU==6] = "PCTermine"

# DataPC$NATURE_PROJET[DataPC$NATURE_PROJET==1] = "Nouvelle construction"
# DataPC$NATURE_PROJET[DataPC$NATURE_PROJET==2] = "Travaux sur construction existante"
DataPC1=subset(DataPC, NATURE_PROJET=="1")
DataPC2=subset(DataPC, NATURE_PROJET=="2")

# fig1 <- plot_ly(DataPC1, type = 'scatter', mode = 'lines', fill = 'tonexty')%>%
#   add_trace(x = ~Etat_DAU, y = ~counts, colors=~year)%>%
#   layout(title = 'value')
# fig1


#Creer MyFunction
MyFunction <- function(df1,df2,x,y,a,b,colors1,colors2,title1,title2){
  
  fig1 <- plot_ly(df1, x = ~x, y = ~y, type = 'bar',color=~colors1, legendgroup=~moisAnnee )
  
  fig1 <- fig1 %>% layout(yaxis = list(title = title1),xaxis = list(title = '') , barmode = 'group')
  
  # fig1
  
  fig2 <- plot_ly(df2, x = ~a, y = ~b, type = 'bar',color=~colors2, legendgroup=~moisAnnee, showlegend=F )
  
  fig2 <- fig2 %>% layout(yaxis = list(title = title2), barmode = 'group')
  
  # fig2
  
  # fig2 <- plot_ly(DataPC2, type = 'scatter', mode = 'lines',colors=~year fill = 'tonexty')%>%
  #   add_trace(x = ~Etat_DAU, y = ~counts, name = 'Etat_DAU_Nature_Projet_Construction_existante')%>%
  #   layout(  title = 'value')
  # 
  fig <- subplot(fig1, fig2,
                 nrows = 2, titleY = TRUE, titleX = TRUE) %>% layout(
                   xaxis = list(zerolinecolor = '#ffff',
                                zerolinewidth = 2,
                                gridcolor = 'ffff'),
                   yaxis = list(zerolinecolor = '#ffff',
                                zerolinewidth = 2,
                                gridcolor = 'ffff'),
                   plot_bgcolor='#e5ecf6')
  fig  

  
}
MyFunction(DataPC1,DataPC2,DataPC1$Etat_DAU,DataPC1$counts,DataPC2$Etat_DAU,DataPC2$counts,DataPC1$moisAnnee,DataPC2$moisAnnee,'Count sur Nouvelle construction','Count construction existante')
