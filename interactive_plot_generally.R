#libraries
library(dplyr)
library(tidyr)
library(data.table)
library(lubridate)
library(ggplot2)
library(cowplot)
library(gridExtra )
library(plotly)

#load data
DataPC=read.csv2("./data/residentiel/PC_DP_créant_logements_2013_2021_Dep25_pc.csv", sep=';')
#filtrer data base
DataPC=select(DataPC,Etat_DAU,
              DATE_REELLE_AUTORISATION,
              CAT_DEM,
              REC_ARCHI,ADR_CODPOST_TER,
              NATURE_PROJET, UTILISATION,RES_PRINCIP_OU_SECOND, TYP_ANNEXE,RESIDENCE_SERVICE)

# DataPC=subset(DataPC,Etat_DAU=='2')

DataPC$Etat_DAU=as.character(DataPC$Etat_DAU)


labels <- function(size, label) {
  list(
    args = c("xbins.size", size), 
    label = label, 
    method = "restyle"
  )
}

fig <- DataPC %>%
  plot_ly(
    x = ~DATE_REELLE_AUTORISATION,
    color=~Etat_DAU,
    autobinx = FALSE, 
    autobiny = TRUE, 
    # marker = list(color = "rgb(68, 68, 68)"), 
    # name = "date", 
    type = "histogram", 
    xbins = list(
      end =  "2021-12-31", 
      size = "D1", 
      start = "2012-12-31"
    )
  )
fig <- fig %>% layout(
  barmode='stack',
  # paper_bgcolor = "rgb(240, 240, 240)",
  # plot_bgcolor = "rgb(240, 240, 240)", 
  title = "<b>Le big zok</b><br>use dropdown to change time serie size",
  xaxis = list(
    type = 'date'
  ),
  yaxis = list(
    title = "zok"
  ),
  updatemenus = list(
    list(
      x = 0.1, 
      y = 1.15,
      active = 1, 
      showactive = TRUE,
      buttons = list(
        labels("D1", "Day"),
        labels("M1", "Month"),
        labels("M6", "Half Year"),
        labels("M12", "Year")
      )
    )
  )
)

fig