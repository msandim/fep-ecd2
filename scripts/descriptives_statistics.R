library(wordcloud)
library(tm)

# http://www.r-bloggers.com/sentiment-analysis-on-donald-trump-using-r-and-tableau/

preprocessed_data <- original_data

######################################
#           Create word cloud
######################################

generate.cloud <- function(candidate_str)
{
  print(candidate_str)
  subset_data <- subset(preprocessed_data, candidate == candidate_str)

  # Create corpus
  corpus <- Corpus(VectorSource(subset_data$text))
  
  # Remove stopwords
  corpus <- tm_map(tm_text, removeWords, stopwords("english"))
  
  # convert corpus to a Plain Text Document
  corpus <- tm_map(corpus, PlainTextDocument)
  
  col <- brewer.pal(6,"Dark2")
  png(paste(candidate_str,"wordcloud.png"), width=1280,height=800)
  wordcloud(corpus, min.freq=25, scale=c(5,2),rot.per = 0.25,
            random.color=T, max.word=45, random.order=F ,colors=col)
}

candidates_names <- unique(preprocessed_data$candidate)
lapply(candidates_names, generate.cloud)

##########################################
#      Frequencies about the posts
##########################################

frequenciesCandidates <- table(preprocessed_data$candidate)
frequenciesSubject <- table(preprocessed_data$subject_matter)

##########################################
#      Plots candidates
##########################################

frequenciesCandidates <- as.data.frame(frequenciesCandidates)
colnames(frequenciesCandidates)[1] <- "Candidate"
frequenciesCandidates <- frequenciesCandidates[-c(1), ]

library(ggplot2)
ggplot(data=frequenciesCandidates, aes(x=Candidate, y=Freq, fill=Candidate)) +
  geom_bar(stat="identity") +
  guides(fill=FALSE) +
  geom_text(aes(label=Freq), position=position_dodge(width=0.9), vjust = -0.5)

##########################################
#      Plots subject
##########################################

frequenciesSubject <- as.data.frame(frequenciesSubject)
colnames(frequenciesSubject)[1] <- "Subject"
frequenciesSubject <- frequenciesSubject[-c(1), ]

library(ggplot2)
ggplot(data=frequenciesSubject, aes(x=Subject, y=Freq, fill=Subject)) +
  geom_bar(stat="identity") +
  guides(fill=FALSE) +
  geom_text(aes(label=Freq), position=position_dodge(width=0.9), vjust = -0.5)