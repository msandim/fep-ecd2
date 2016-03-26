library(plyr)
library(dplyr)
library(stringr)
library(ggplot2)
library(tm)
library(Rstem)

#https://jeffreybreen.wordpress.com/2011/07/04/twitter-text-mining-r-slides/

pos.words <- read.table("positive-words.txt")
neg.words <- read.table("negative-words.txt")

#if needed add more words to the lists

#evaluation tweets function

sentence = data[29,2]

score.sentiment <- function(sentences, pos.words, neg.words, .progress='none')
{
  require(plyr)
  require(stringr)
  require(tm)
  scores <- laply(sentences, function(sentence, pos.words, neg.words){
    word.list <- strsplit(sentence, " ")
    words <- unlist(word.list)
    words <- wordStem(words, language="english")
    pos.matches <- match(words, pos.words)
    neg.matches <- match(words, neg.words)
    pos.matches <- !is.na(pos.matches)
    neg.matches <- !is.na(neg.matches)
    score <- sum(pos.matches) - sum(neg.matches)
    return(score)
  }, pos.words, neg.words, .progress=.progress)
  scores.df <- data.frame(score=scores, text=sentences)
  return(scores.df)
}

scores <- score.sentiment(data$text, pos.words, neg.words, .progress='text')
