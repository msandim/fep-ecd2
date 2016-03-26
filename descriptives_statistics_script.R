
library(wordcloud)

# http://www.r-bloggers.com/sentiment-analysis-on-donald-trump-using-r-and-tableau/

######################################
#           Create word cloud
######################################

# Create corpus
corpus=Corpus(VectorSource(data$text))

# Convert to lower-case
corpus=tm_map(corpus,tolower)

# Remove stopwords
corpus=tm_map(corpus,function(x) removeWords(x,stopwords()))

# convert corpus to a Plain Text Document
corpus=tm_map(corpus,PlainTextDocument)

col=brewer.pal(6,"Dark2")
wordcloud(corpus, min.freq=25, scale=c(5,2),rot.per = 0.25,
          random.color=T, max.word=45, random.order=F,colors=col)