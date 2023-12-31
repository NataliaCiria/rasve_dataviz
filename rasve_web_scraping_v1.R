library(httr)
library(jsonlite)
library(rvest)
library(dplyr)

get_rasve_table<-function(url="https://servicio.mapa.gob.es/rasve/Publico/Publico/BuscadorFocos.aspx", maxpage=10){
  s <- session(url)
  
  form<-html_form(s)[[2]]
  
  s<-session_submit(s, form, submit = "btnbuscar")
  
  rasve_table<- html_table(read_html(s, encoding="UTF-8"))[[1]]
  
  next_page<-TRUE
  npage<-1
  
  while(next_page){
    npage=npage+1
    url_next <-paste0("https://servicio.mapa.gob.es/rasve/Publico/Publico/BuscadorFocos.aspx?currentpage=",npage)
    
    s<-session_jump_to(s, url_next)
    
    rasve_table_next<-html_table(read_html(s, encoding="UTF-8"))
    
    if(length(rasve_table_next)>0){
      rasve_table_next<-rasve_table_next[[1]]
      rasve_table<-rbind(rasve_table,rasve_table_next)
    }else{
      next_page<-FALSE
    }
    
    #Stop at maxpage (avoid infinite loop)
    if(npage==maxpage){
      next_page<-FALSE
      
    }
    
  }
  
  return(rasve_table)
  
  
}

#ES_TB_url<-"https://servicio.mapa.gob.es/rasve/Publico/Publico/BuscadorFocos.aspx?cmbpais=11&cmbenfermedades=274"
rasve_data<-read.csv("rasve_data.csv", sep=";", row.names = NULL, check.names=FALSE)
rasve_data$`Fecha de confirmación`<- as.Date(rasve_data$`Fecha de confirmación`, format = "%d/%m/%Y")

rasve_new_data<-get_rasve_table()
rasve_new_data$`Fecha de confirmación`<- as.Date(rasve_new_data$`Fecha de confirmación`, format = "%d/%m/%Y")
dim(rasve_data)
dim(rasve_new_data)

if(any(rasve_new_data$`Fecha de confirmación`>max(rasve_data$`Fecha de confirmación`))){
  rasve_data<-rbind(rasve_new_data,rasve_data)
}


#update last event
if(new_last_event>last_event){
  last_event<-new_last_event
  save(last_event, file="last_event.Rdata")
}
