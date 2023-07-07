library(dplyr)
library(tidyr) #Data cleaning
library(ggplot2) #Plot graphs

outbreaks<-read.csv("animal_outbreaks.csv", sep=";", stringsAsFactors = TRUE)

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
