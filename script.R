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

# text cleaning: http://colinpriest.com/2015/07/04/tutorial-using-r-and-twitter-to-analyse-consumer-sentiment/
some_txt = data[4,2]
  
  
# remove retweet entities
some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt)
# remove at people
some_txt = gsub("@\\w+", "", some_txt)
# remove punctuation
some_txt = gsub("[[:punct:]]", "", some_txt)
# remove numbers
some_txt = gsub("[[:digit:]]", "", some_txt)
# remove html links
some_txt = gsub("http\\w+", "", some_txt)

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
some_txt = sapply(some_txt, try.error)

# remove NAs in some_txt
some_txt = some_txt[!is.na(some_txt)]
names(some_txt) = NULL
  




