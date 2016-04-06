library(qdap)
library(data.table)

#http://www.r-bloggers.com/statistics-meets-rhetoric-a-text-analysis-of-i-have-a-dream-in-r/

#qdaps sentiment analysis is based on a sentence-level formula classifying each word as either positive, negative, neutral, negator or amplifier, per Hu & Liu’s sentiment lexicon. The function also provides a word count.

pol.df <- polarity(data$text)$all

#add this result to the data
sentiment_scores_qdap <- data.frame("sentiment" = pol.df$polarity,
                                    "text" = pol.df$text)
write.csv(sentiment_scores_qdap, file = "sentiment_qdap.csv", fileEncoding = "utf-8", row.names=FALSE)

