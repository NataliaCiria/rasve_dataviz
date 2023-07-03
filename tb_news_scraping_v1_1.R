#Web scraping from https://rpubs.com/Semilla_389/989829
library(tidyverse) # para manipular datos
library(rvest)     # permite realizar web scraping
library(polite)    # verificación de robots.txt para web scraping
library(lubridate) # tabajar con datos tipo fecha
library(wordcloud) # Crear nubes de palabras
library(tidytext)  # Manejo de datos tipo texto 
library(tm)        # Manejo de texto StopWords
library(httr)
library(jsonlite)

#token <-'"x-api-key": "DYjh_l6YqOjwSKe6DY3E3mtA_VABFplsb9SQTpZNP04"' 
#news_json<-GET("https://api.newscatcherapi.com/v2/search?q=tuberculosisANDbovina&countries=ES",add_headers(Authorization=token))

news<-read.csv("news_output_page_1.csv")
stop_words_spanish <- data.frame(word = stopwords("spanish"))

ngrama <-
  news %>%
  select(title) %>%
  # desanida el texto completo por palabra n = 1
  unnest_tokens(output = "word", title, token = "ngrams", n = 1) %>%
  # elimina las stopwords (palabras NO informativas)
  anti_join(stop_words_spanish) %>%
  # conteo del número de veces que aparece cada palabra
  count(word)


wordcloud(
  words = ngrama$word,
  freq = ngrama$n,
  max.words = 100,
  random.order = FALSE)
