library(dplyr)
library(tidyr)
library(stringr)

library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(ggplot2)
library(ggrepel)

set.seed(1234)

# for pub-date > 2012 and ("data stream")[All Sources(Computer Science,Decision Sciences,Economics, Econometrics and Finance,Engineering,Mathematics)]. 

getKeywordsScienceDirect <- function(fileName)
{
  file <- readLines(fileName)
  numberArticles <- sum(!is.na(str_extract(file, "(?<=Keywords: )[:print:]*")))
  
  keywords <- str_extract(file, "(?<=Keywords: )[:print:]*")
  keywords <- str_split(keywords, "; ")
  keywords <- unlist(keywords)
  keywords <- keywords[!is.na(keywords)]
  keywords <- tolower(keywords)
  keywords <- keywords %>% str_replace_all("data streams", "data stream") %>%
    str_replace_all("data stream clustering", "clustering") %>%
    str_replace_all("data clustering", "clustering") %>%
    str_replace_all("real time", "real-time") %>%
    str_replace_all("big data analytics", "big data") %>%
    str_replace_all("big data stream", "big data") %>%
    str_replace_all("multimedia big data", "big data") %>%
    str_replace_all("synchronous big data", "big data")
  
  keywords.data <- tbl_df(as.data.frame(table(keywords))) %>% mutate(Freq2 = Freq/numberArticles) %>% arrange(desc(Freq2))
  return(keywords.data)
}

getKeywordsScopus <- function(fileName)
{
  trim <- function (x) gsub("^\\s+|\\s+$", "", x)
  scopus <- tbl_df(read.csv(fileName, stringsAsFactors = FALSE))
  numberArticles = nrow(scopus)
  
  keywords <- scopus %>% mutate(keywords = paste(Author.Keywords, Index.Keywords)) %>% `$`(keywords) %>% trim
  keywords <- str_split(keywords, "; ") %>% unlist %>% tolower
  keywords <- keywords[!is.na(keywords)]
  keywords <- keywords %>% str_replace_all("data streams", "data stream") %>%
    str_replace("data stream mining", "data stream") %>%
    str_replace_all("data stream clustering", "clustering") %>%
    str_replace_all("data clustering", "clustering") %>%
    str_replace_all("real time", "real-time") %>%
    str_replace_all("big data analytics", "big data") %>%
    str_replace_all("big data stream", "big data") %>%
    str_replace_all("multimedia big data", "big data") %>%
    str_replace_all("synchronous big data", "big data")
  
  keywords <- keywords[keywords != ""]
  keywords <- keywords[keywords != "data stream"]
  
  keywords.data <- tbl_df(as.data.frame(table(keywords), stringsAsFactors = FALSE)) %>% mutate(Freq2 = Freq/numberArticles, numberArticles = numberArticles) %>% arrange(desc(Freq2))
  return(keywords.data)
}

#getKeywordsScienceDirect("science_2005.txt") %>% View("Science 2005")
#getKeywordsScienceDirect("science_2010.txt") %>% View("Science 2010")
#getKeywordsScienceDirect("science_2015.txt") %>% View("Science 2015")

scopus2005 <- getKeywordsScopus("scopus_2005.csv") %>% top_n(10, Freq2)
scopus2010 <- getKeywordsScopus("scopus_2010.csv") %>% top_n(10, Freq2)
scopus2015 <- getKeywordsScopus("scopus_2015.csv") %>% top_n(10, Freq2)

scopus2005 %>% head(10)
scopus2010 %>% head(10)
scopus2015 %>% head(10)

plotPoints <- function()
{
  
  scopus <- scopus2005 %>% select(-Freq) %>% rename("2005" = Freq2) %>%
    full_join(scopus2010, by="keywords") %>% select(-Freq) %>% rename("2010" = Freq2) %>% 
    full_join(scopus2015, by="keywords") %>% select(-Freq) %>%rename("2015" = Freq2) %>%
    gather(Year, Freq, 2:4) %>% filter(!is.na(Freq))
  
  ggplot(scopus) +
    geom_point(aes(x=Year, y=Freq), shape=1) +
    geom_line(aes(x=Year, y=Freq, group = keywords), size=0.4, color="red") +
    geom_text_repel(
      aes(x=Year, y=Freq, fill=Year, color = Year, label = keywords),
      segment.color = "darkgrey",
      size = 4,
      box.padding = unit(0.7, "lines"),
      point.padding = unit(0.5, "lines"))
  #nudge_x = ifelse(scopus$Year == 2005, -0.4, 0.4)) +
  theme(legend.position="none")
  
  ggsave("lol.pdf", width=9, height=9)
}