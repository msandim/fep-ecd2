library(tm)

######################################
#            Prepare data
######################################

#read the csv
data <- read.csv("GOF_data.csv")

old_data <- data

#delete not needed columns

data <- data.frame("id" = old_data$id,
                   "text" = old_data$text,
                   "candidate" = old_data$candidate,
                   "candidate_confidence" = old_data$candidate_confidence,
                   "subject_matter" = old_data$subject_matter,
                   "subject_matter_confidence" = old_data$subject_matter_confidence,
                   "sentiment" = old_data$sentiment,
                   "sentiment_confidence" = old_data$sentiment_confidence
                   ) 

# text cleaning:
  




