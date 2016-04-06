#load data
data <- read.csv("GOF_data.csv")
sentiment_scores_manual <- read.csv("sentiment_manual.csv")
sentiment_scores_qdap <- read.csv("sentiment_qdap.csv")

# convert the numeric sentiment values to classes
attach(sentiment_scores_manual)
sentiment_scores_manual$str[score > 0] <- "Positive"
sentiment_scores_manual$str[score == 0] <- "Neutral"
sentiment_scores_manual$str[score < 0] <- "Negative"
detach(sentiment_scores_manual) 

#do the confusion matrix to check the accuracy of the model 
conf.matrix = confusionMatrix(data$sentiment, sentiment_scores_manual$str)

attach(sentiment_scores_qdap)
sentiment_scores_qdap$str[sentiment > 0] <- "Positive"
sentiment_scores_qdap$str[sentiment == 0] <- "Neutral"
sentiment_scores_qdap$str[sentiment < 0] <- "Negative"
