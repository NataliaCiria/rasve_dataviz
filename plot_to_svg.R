library(dplyr) #Data transformation
library(tidyr) #Data cleaning
library(ggplot2) #Plot graphs
library(svglite) #Create SVG files

#load data
disease_ranking<-read.csv("disease_ranking.csv")

disease_ranking%>%
  ggplot(aes(x=Year, y=Rank,colour=disease))+
  geom_point(show.legend = F)+
  geom_line(linetype="dotted",show.legend = F)+
  scale_y_reverse()+
  scale_color_hue(h=c(15,250),l=50, c=100)+  
  theme_void()

ggsave("disease_ranking.svg")

install.packages("svglite")
