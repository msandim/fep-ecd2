library(caret)

# Produces several validation statistics:
# y: Factor vector of true values
# predictions: Factor vector of the predicted values
# positiveClass: Name, as a string, of the positive class
# negativeClass: Name, as a string, of the negative class
validationStatistics <- function (predictions, y, positiveClass, negativeClass)
{
  # Calculate precision and recall:
  result <- confusionMatrix(lol, lol2, positiveClass)
  precision <- result$byClass[['Pos Pred Value']]
  recall <- result$byClass[['Sensitivity']]
  
  # Calculate F1:
  f1 <- 2 * precision * recall / (precision + recall)
  
  return(list(precision = precision, recall = recall, f1 = f1))
}

# Para confirmar os resultados:
# lol <- as.factor(c("pos", "neg", "pos", "neg", "neg"))
# lol2 <- as.factor(c("pos", "pos", "neg", "pos", "neg"))
# result <- confusionMatrix(lol, lol2, "pos")
# precision <- result$byClass['Pos Pred Value']    
# recall <- result$byClass['Sensitivity']