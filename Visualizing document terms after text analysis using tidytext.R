#Visualizing document terms after text analysis using tidytext
getwd()
rm(list = ls())

#read file
data <- readLines('modi.txt')
View(data)
data
which(!complete.cases(data)) #nothing incomplete/NA

#text mining:
library(tm)
corpus <- Corpus(VectorSource(data))
inspect(corpus[10:12])
dtm <- DocumentTermMatrix(corpus, control = list(tolower = T,
                                                 removeNumbers = T,
                                                 removePunctuation = T,
                                                 stopwords = T,
                                                 stripWhitespace = T,
                                                 stemDocument = T))

View(dtm)
class(dtm) #documentTermMatrix
typeof(dtm) #list
dim(dtm)
inspect(dtm) #99% sparse
head(Terms(dtm),n=20) #spits out first 20 terms

#tidytext
library(tidytext)
df <- tidy(dtm) #similarly you can form 'df' from 'dfm' of 'quanteda'
View(df)
class(df) #tbl/df
typeof(df) #list
unique(df$document)

#installing 'drlib' function for visualizing ordered bars with facets 
devtools::install_github("dgrtwo/drlib") 
packageDescription("drlib")

library(drlib)
library(dplyr)
library(ggplot2)
df %>%
  group_by(document) %>%
  top_n(5) %>%
  ungroup() %>%
  mutate(document = factor(as.numeric(document), levels = 1:17)) %>%
  ggplot(aes(drlib::reorder_within(term, count, document), count)) +
  geom_bar(stat = "identity") +
  xlab("Top 5 Common Words") +
  drlib::scale_x_reordered() +
  coord_flip()+
  facet_wrap(~ document, scales = "free")

