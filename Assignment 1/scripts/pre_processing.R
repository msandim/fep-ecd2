library(tm)

preProcessing <- function(stem)
{
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
                              "sentiment_confidence" = original_data$sentiment_confidence)
  
  original_data$text <- as.character(original_data$text)
  
  # text cleaning: http://colinpriest.com/2015/07/04/tutorial-using-r-and-twitter-to-analyse-consumer-sentiment/
  #text <- original_data$text
  
  ################################
  ##### Text cleaning ############
  ################################
  
  # Remove non-ASCII characters:
  Encoding(original_data$text) <- "latin1"
  original_data$text <- iconv(original_data$text, "latin1", "ASCII", sub="")
  
  ## Twitter related:
  # Remove retweet entities
  original_data$text <- gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", original_data$text)
  # Remove @ people
  original_data$text <- gsub("@\\w+", "", original_data$text)
  # Remove html links
  original_data$text <- gsub("http[^[:space:]]*", "", original_data$text)
  
  ## Other:
  tm_text <- Corpus(VectorSource(original_data$text))
  
  # Remove numbers:
  tm_text <- tm_map(tm_text, removeNumbers)   
  # To lowercase:
  tm_text <- tm_map(tm_text, content_transformer(tolower))
  # Remove common words in english language:
  #tm_text <- tm_map(tm_text, removeWords, stopwords("english"))
  # Remove ponctuation:
  tm_text <- tm_map(tm_text, removePunctuation)
  # Remove whitespace:
  tm_text <- tm_map(tm_text, stripWhitespace)
  # Text stemming:
  if (stem)
    tm_text <- tm_map(tm_text, stemDocument)
  
  original_data$text <- unlist(sapply(tm_text, `[`, "content"))
  
  ####################################
  ######## Filter data rows ##########
  ####################################
  
  # Delete neutrals
  original_data <- original_data[original_data$sentiment != "Neutral",]
  original_data$sentiment <- factor(original_data$sentiment)
  # Process no candidate mentioned
  original_data$candidate[original_data$candidate == ""] <- "No candidate mentioned"
  original_data$candidate <- factor(original_data$candidate)
  
  return(original_data)
}

original_data <- preProcessing(stem = FALSE)
original_data_stemming <- preProcessing(stem = TRUE)