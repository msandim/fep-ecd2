library(tm)

#setwd("~/fep-ecd2")

######################################
#            Prepare data
######################################

#read the csv
data <- read.csv("csv_data/GOF_data.csv")

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

# text cleaning: http://colinpriest.com/2015/07/04/tutorial-using-r-and-twitter-to-analyse-consumer-sentiment/
text <- data$text

# remove retweet entities
text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", text)
# remove at people
text = gsub("@\\w+", "", text)
# remove punctuation
text = gsub("[[:punct:]]", "", text)
# remove numbers
text = gsub("[[:digit:]]", "", text)
# remove html links
text = gsub("http\\w+", "", text)

# define "tolower error handling" function
try.error = function(x)
{
  # create missing value
  y = NA
  # tryCatch error
  try_error = tryCatch(tolower(x), error=function(e) e)
  # if not an error
  if (!inherits(try_error, "error"))
    y = tolower(x)
  # result
  return(y)
}
# lower case using try.error with sapply
text = sapply(text, try.error)

data$text <- text
  




