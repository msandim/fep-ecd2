library(caret)

# convert the numeric sentiment values to classes


attach(sentiment_scores_manual)
sentiment_scores_manual$str[score > 0] <- "Positive"
sentiment_scores_manual$str[score == 0] <- "Neutral"
sentiment_scores_manual$str[score < 0] <- "Negative"
detach(sentiment_scores_manual) 

conf.matrix = confusionMatrix(data$sentiment, sentiment_scores_manual$str)

attach(sentiment_scores_qdap)
sentiment_scores_qdap$str[polarity > 0] <- "Positive"
sentiment_scores_qdap$str[polarity == 0] <- "Neutral"
sentiment_scores_qdap$str[polarity < 0] <- "Negative"
detach(sentiment_scores_qdap) 

conf.matrix2 = confusionMatrix(data$sentiment, sentiment_scores_qdap$str)
