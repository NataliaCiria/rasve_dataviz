library(dplyr)
library(tidyr) #Data cleaning
library(ggplot2) #Plot graphs
dictionary<-read.csv("dictionary.csv", sep=";", stringsAsFactors = TRUE)
rasve_data<-read.csv("rasve_data.csv", sep=";", stringsAsFactors = TRUE)
names(rasve_data)<-dictionary$key[dictionary$section=="header"]

#Add data format
rasve_data$confirmation_date<-as.Date(rasve_data$confirmation_date,"%d/%m/%Y")

#Filter to 2024-01-01
rasve_data<-rasve_data[rasve_data$confirmation_date<"2024-01-01",]

outbreaks<-rasve_data%>%
  mutate(outbreak_n=1,
    index=row_number(),
    code=gsub(" ","",code))%>%
  arrange(desc(index))%>% 
  group_by(code)%>%
  mutate(outbreak_n=cumsum(outbreak_n),
         outbreak_id=paste0(code,"_",outbreak_n))%>% 
  arrange(index)%>% 
  ungroup()%>%
  left_join(dictionary, by=c("disease" = "lit_es"))%>%
  mutate(disease=lit_en)%>%
  select(-any_of(names(dictionary)))

n_max<-max(outbreaks$n_affected_species, na.rm=TRUE)

susceptible_tb<-outbreaks%>%
  select(outbreak_id,species, susceptible)%>%
  separate(species, paste0("species",1:n_max),sep=", ")%>%
  separate(susceptible,paste0("susceptible",1:n_max),sep=" / ")%>%
  pivot_longer(cols = starts_with("species"),
               names_to = "species_index",
               values_to = "species",
               values_drop_na = TRUE) %>%
  pivot_longer(cols = starts_with("susceptible"),
               names_to = "susceptible_index",
               values_to = "susceptible",
               values_drop_na = TRUE)%>%
  filter(gsub("species","", species_index) == gsub("susceptible","",susceptible_index))%>%
  select(outbreak_id,species, susceptible)

animals<-outbreaks%>%
  select(outbreak_id,species, affected)%>%
  separate(species, paste0("species",1:n_max),sep=", ")%>%
  separate(affected,paste0("affected",1:n_max),sep=" / ")%>%
  pivot_longer(cols = starts_with("species"),
               names_to = "species_index",
               values_to = "species",
               values_drop_na = TRUE) %>%
  pivot_longer(cols = starts_with("affected"),
               names_to = "affected_index",
               values_to = "affected",
               values_drop_na = TRUE)%>%
  filter(gsub("species","", species_index) == gsub("affected","",affected_index))%>%
  left_join(susceptible_tb, relationship = "many-to-many")%>%
  left_join(dictionary, by=c("species" = "lit_es"))%>%
  mutate(species=lit_en)%>%
  select(outbreak_id,species, affected, susceptible)
  
write.csv(outbreaks, "outbreaks.csv", fileEncoding = "UTF-8")

write.csv(animals, "animals.csv", fileEncoding = "UTF-8")
