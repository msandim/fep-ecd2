library(tm)

#setwd("~/fep-ecd2")

######################################
#            Prepare data
######################################

#read the csv
original_data <- read.csv("csv_data/GOF_data.csv")

#delete not needed columns

original_data <- data.frame("id" = original_data$id,
                   "text" = original_data$text,
                   "candidate" = original_data$candidate,
                   "candidate_confidence" = original_data$candidate_confidence,
                   "subject_matter" = original_data$subject_matter,
                   "subject_matter_confidence" = original_data$subject_matter_confidence,
                   "sentiment" = original_data$sentiment,
                   "sentiment_confidence" = original_data$sentiment_confidence
                   ) 

# text cleaning: http://colinpriest.com/2015/07/04/tutorial-using-r-and-twitter-to-analyse-consumer-sentiment/
#text <- original_data$text

################################
##### Text cleaning ############
################################

# remove retweet entities
original_data$text = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", original_data$text)
# remove at people
original_data$text = gsub("@\\w+", "", original_data$text)
# remove punctuation
original_data$text = gsub("[[:punct:]]", "", original_data$text)
# remove numbers
original_data$text = gsub("[[:digit:]]", "", original_data$text)
# remove html links
original_data$text = gsub("http\\w+", "", original_data$text)

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
original_data$text = sapply(original_data$text, try.error)

####################################
######## Filter data rows ##########
####################################

original_data <- original_data[original_data$sentiment != "Neutral",]
original_data$sentiment <- factor(original_data$sentiment)
