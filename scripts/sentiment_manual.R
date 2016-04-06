library(plyr)
library(dplyr)
library(stringr)
library(ggplot2)
library(tm)
library(Rstem)

# Run pre_processing.R before running this

sentimentManual <- function()
{
  #https://jeffreybreen.wordpress.com/2011/07/04/twitter-text-mining-r-slides/
  
  pos.words <- read.table("csv_data/positive-words.txt")
  neg.words <- read.table("csv_data/negative-words.txt")
  
  #if needed add more words to the lists
  
  #evaluation tweets function
  
  score.sentiment <- function(sentences, pos.words, neg.words, .progress='none')
  {
    scores <- laply(sentences, function(sentence, pos.words, neg.words){
      word.list <- strsplit(sentence, " ")
      words <- unlist(word.list)
      words <- wordStem(words, language="english") #e. g. winning -> win (in slides) homeless home
      pos.matches <- match(words, pos.words$V1)
      neg.matches <- match(words, neg.words$V1)
      pos.matches <- !is.na(pos.matches)
      neg.matches <- !is.na(neg.matches)
      score <- sum(pos.matches) - sum(neg.matches)
      return(score)
    }, pos.words, neg.words, .progress=.progress)
    
    scores.df <- data.frame("score" = scores, "text" = sentences)
    return(scores.df)
  }
  
  sentiment_scores_manual <- score.sentiment(original_data$text, pos.words, neg.words, .progress='text')
  write.csv(sentiment_scores_manual, file = "csv_data/sentiment_manual.csv", row.names=FALSE)
}

sentimentManual()