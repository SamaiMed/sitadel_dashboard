affich_graph <-function(df,var,Date,EndDate,StartDate) {
  var=as.character(var)
  
  labels <- function(size, label) {
    list(
      args = c("xbins.size", size), 
      label = label, 
      method = "restyle"
    )
  }
  
  fig <- df %>%
    plot_ly(
      x = ~Date,
      color=~var,
      autobinx = FALSE, 
      autobiny = TRUE, 
      type = "histogram", 
      xbins = list(
        end =  EndDate, 
        size = "D1", 
        start = StartDate
      )
    )
  fig <- fig %>% layout(
    barmode='stack',
  
    title = "<b>histogram PC Autorise-Annule-Commence-Terminé</b><br>use dropdown to change time serie size",
    xaxis = list(
      type = 'date'
    ),
    yaxis = list(
      title = "Nbr Permis de construction "
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
  
  
  
}
#load data
DataPC=read.csv2("./data/residentiel/PC_DP_créant_logements_2013_2021_Dep25_pc.csv", sep=';')
#filtrer data base
DataPC=select(DataPC,Etat_DAU,
              DATE_REELLE_AUTORISATION,
              CAT_DEM,
              REC_ARCHI,ADR_CODPOST_TER,
              NATURE_PROJET, UTILISATION,RES_PRINCIP_OU_SECOND, TYP_ANNEXE,RESIDENCE_SERVICE)


affich_graph(DataPC,DataPC$NATURE_PROJET,DataPC$DATE_REELLE_AUTORISATION,"2021-12-31","2012-12-31")
