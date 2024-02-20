library(dplyr) #Data transformation
library(tidyr) #Data cleaning

#load data
outbreaks<-read.csv("outbreaks.csv")
animals<-read.csv("animals.csv")

outbreaks_summary<-outbreaks%>%
  mutate(year = substr(confirmation_date, start = 1, stop = 4)) %>%
  group_by(disease, disease_label,year) %>%
  summarise(outbreaks = n())%>%
  ungroup()

outbreaks_summary<-animals%>%
  left_join(outbreaks, by="outbreak_id")%>%
  mutate(year = substr(confirmation_date, start = 1, stop = 4)) %>%
    group_by(disease, disease_label,year) %>%
    summarise(species=toString(unique(species.x)))%>%
    ungroup()%>%
  left_join(outbreaks_summary)%>%
  arrange(desc(outbreaks))

write.csv(outbreaks_summary, "outbreaks_summary.csv", fileEncoding = "UTF-8")


