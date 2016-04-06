library(caret)

# Make sure to run pre_processing.R before

# #######################################
# ######## PREPARE VALIDATION ###########
# #######################################

# Read results saved before:
sentiment_scores_manual <- read.csv("csv_data/sentiment_manual.csv")
sentiment_scores_qdap_default <- read.csv("csv_data/sentiment_qdap_default.csv")
sentiment_scores_qdap_afinn <- read.csv("csv_data/sentiment_qdap_afinn.csv")

# Convert the numeric sentiment values to classes:
attach(sentiment_scores_manual)
sentiment_scores_manual$sentiment[score >= 0] <- "Positive"
sentiment_scores_manual$sentiment[score < 0] <- "Negative"
sentiment_scores_manual$sentiment <- as.factor(sentiment_scores_manual$sentiment)
detach(sentiment_scores_manual) 

attach(sentiment_scores_qdap_default)
sentiment_scores_qdap_default$sentiment[score >= 0] <- "Positive"
sentiment_scores_qdap_default$sentiment[score < 0] <- "Negative"
sentiment_scores_qdap_default$sentiment <- as.factor(sentiment_scores_qdap_default$sentiment)
detach(sentiment_scores_qdap_default)

attach(sentiment_scores_qdap_afinn)
sentiment_scores_qdap_afinn$sentiment[score >= 0] <- "Positive"
sentiment_scores_qdap_afinn$sentiment[score < 0] <- "Negative"
sentiment_scores_qdap_afinn$sentiment <- as.factor(sentiment_scores_qdap_afinn$sentiment)
detach(sentiment_scores_qdap_afinn)


##########################################
# ######## Evaluation Metrics ############
##########################################

# Produces several validation statistics:
# y: Factor vector of true values
# predictions: Factor vector of the predicted values
# positiveClass: Name, as a string, of the positive class
validationStatistics <- function (predictions, y, positiveClass)
{
  # Calculate precision and recall:
  result <- confusionMatrix(predictions, y, positiveClass)
  precision <- result$byClass[['Pos Pred Value']]
  recall <- result$byClass[['Sensitivity']]
  
  # Calculate F1:
  f1 <- 2 * precision * recall / (precision + recall)
  
  return(list(precision = precision, recall = recall, f1 = f1))
}

# Validate manual approach
validationStatistics(sentiment_scores_manual$sentiment, 
                     original_data$sentiment,
                     "Positive")

# confusionMatrix(sentiment_scores_manual$sentiment, original_data$sentiment, "Positive")

# Validate qdap default approach
validationStatistics(sentiment_scores_qdap_default$sentiment, 
                     original_data$sentiment,
                     "Positive")

# confusionMatrix(sentiment_scores_qdap_default$sentiment, original_data$sentiment, "Positive")

# Validate qdap afinn approach
validationStatistics(sentiment_scores_qdap_afinn$sentiment, 
                     original_data$sentiment,
                     "Positive")

# confusionMatrix(sentiment_scores_qdap_afinn$sentiment, original_data$sentiment, "Positive")