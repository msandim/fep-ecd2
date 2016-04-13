library(caret)

# Make sure to run pre_processing.R before

# #######################################
# ######## PREPARE VALIDATION ###########
# #######################################

# Read results saved before:
sentiment_scores_manual <- read.csv("csv_data/sentiment_manual.csv")
sentiment_scores_manual_stemming <- read.csv("csv_data/sentiment_manual_stemming.csv")
sentiment_scores_qdap_default <- read.csv("csv_data/sentiment_qdap_default.csv")
sentiment_scores_qdap_afinn <- read.csv("csv_data/sentiment_qdap_afinn.csv")
sentiment_scores_qdap_default_stemming <- read.csv("csv_data/sentiment_qdap_default_stemming.csv")
sentiment_scores_qdap_afinn_stemming <- read.csv("csv_data/sentiment_qdap_afinn_stemming.csv")

# Convert the numeric sentiment values to classes:
convertSentimentFactor <- function(data)
{
  data$sentiment[data$score >= 0] <- "Positive"
  data$sentiment[data$score < 0] <- "Negative"
  data$sentiment <- as.factor(data$sentiment)
  return(data)
}

sentiment_scores_manual <- convertSentimentFactor(sentiment_scores_manual)
sentiment_scores_manual_stemming <- convertSentimentFactor(sentiment_scores_manual_stemming)
sentiment_scores_qdap_default <- convertSentimentFactor(sentiment_scores_qdap_default)
sentiment_scores_qdap_afinn <- convertSentimentFactor(sentiment_scores_qdap_afinn)
sentiment_scores_qdap_default_stemming <- convertSentimentFactor(sentiment_scores_qdap_default_stemming)
sentiment_scores_qdap_afinn_stemming <- convertSentimentFactor(sentiment_scores_qdap_afinn_stemming)



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
  print(result)
  precision <- result$byClass[['Pos Pred Value']]
  recall <- result$byClass[['Sensitivity']]
  
  # Calculate F1:
  f1 <- 2 * precision * recall / (precision + recall)
  
  return(list(precision = precision, recall = recall, f1 = f1))
}

#################################
# 1 - Precision, Recall, F1:
#################################

# Validate manual approach:
res_man <- validationStatistics(sentiment_scores_manual$sentiment, original_data$sentiment, "Positive")

# Validate manual approach (stemming):
res_man_stem <- validationStatistics(sentiment_scores_manual_stemming$sentiment, original_data_stemming$sentiment, "Positive")

# Validate qdap default approach:
res_qdap_deafault <- validationStatistics(sentiment_scores_qdap_default$sentiment, original_data$sentiment, "Positive")

# Validate qdap afinn approach:
res_qdap_afinn <- validationStatistics(sentiment_scores_qdap_afinn$sentiment, original_data$sentiment, "Positive")

# Validate qdap default approach (stemming):
res_qdap_deafault_stem <- validationStatistics(sentiment_scores_qdap_default_stemming$sentiment, original_data_stemming$sentiment, "Positive")

# Validate qdap afinn stemming (stemming);
res_qdap_afinn_stem <- validationStatistics(sentiment_scores_qdap_afinn_stemming$sentiment, original_data_stemming$sentiment, "Positive")

###############
#making a table
###############

res_man <- as.data.frame(res_man)
res_man$test <- "manual"

res_man_stem <- as.data.frame(res_man_stem)
res_man_stem$test <- "manual with stemming"
res_man <- rbind(res_man, res_man_stem)

res_qdap_deafault <- as.data.frame(res_qdap_deafault)
res_qdap_deafault$test <- "qdap default"
res_man <- rbind(res_man, res_qdap_deafault)

res_qdap_afinn <- as.data.frame(res_qdap_afinn)
res_qdap_afinn$test <- "qdap afinn"
res_man <- rbind(res_man, res_qdap_afinn)


res_qdap_deafault_stem <- as.data.frame(res_qdap_deafault_stem)
res_qdap_deafault_stem$test <- "qdap default stemming"
res_man <- rbind(res_man, res_qdap_deafault_stem)

res_qdap_afinn_stem <- as.data.frame(res_qdap_afinn_stem)
res_qdap_afinn_stem$test <- "qdap afinn stemming"
res_man <- rbind(res_man, res_qdap_afinn_stem)

