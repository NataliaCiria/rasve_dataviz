library(dplyr)
library(tidyr) #Data cleaning
library(ggplot2) #Plot graphs

outbreaks<-read.csv("rasve_data.csv", sep=";", stringsAsFactors = TRUE)%>%
  mutate(`N foco`=1,
    index=row_number())%>%
  arrange(desc(index))%>% 
  group_by(`Código`)%>%
  mutate(`n_foco`=cumsum(`N foco`),
    id_foco=paste0(`Código`,"_",`n_foco`))%>% 
  arrange(index)%>% 
  ungroup()

animals<-outbreaks%>%
  select(outbreak_id, starts_with("susceptible"))%>%
  pivot_longer(cols=starts_with("susceptible"), names_to = "species", values_to="susceptible")%>%
  mutate(species=gsub("susceptible_","",species))

animals<-outbreaks%>%
  select(outbreak_id, starts_with("affected"))%>%
  pivot_longer(cols=starts_with("affected"), names_to = "species", values_to="affected")%>%
  mutate(species=gsub("affected_","",species))%>%
  left_join(animals, relationship = "many-to-many")

write.csv(animals, "animals.csv")
