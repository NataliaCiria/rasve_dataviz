library(dplyr) #Data transformation
library(tidyr) #Data cleaning

#load data
outbreaks<-read.csv("outbreaks.csv")

outbreaks_summary<-outbreaks%>%
  mutate(year = substr(confirmation_date, start = 1, stop = 4)) %>%
  group_by(disease, year) %>%
  summarise(outbreaks = n())

write.csv(outbreaks_summary, "outbreaks_summary.csv", fileEncoding = "UTF-8")
