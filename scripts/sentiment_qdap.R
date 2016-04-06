library(qdap)
library(data.table)

#http://www.r-bloggers.com/statistics-meets-rhetoric-a-text-analysis-of-i-have-a-dream-in-r/

#qdaps sentiment analysis is based on a sentence-level formula classifying each word as either positive, negative, neutral, negator or amplifier, per Hu & Liu’s sentiment lexicon. The function also provides a word count.
dictionary_AFINN <- read.csv("csv_data/AFINN-111.txt", stringsAsFactors = FALSE, header=FALSE, sep="\t", encoding ="UTF-8")
dictionary_ANEW <- read.csv("csv_data/AFINN-111.txt", stringsAsFactors = FALSE, header=FALSE, sep="\t", encoding ="UTF-8")

pol.df_Default <- polarity(data$text)$all
pol.df_AFINN <- polarity(data$text, polarity.frame = dictionary_AFINN)$all
pol.df_ANEW <- polarity(data$text, polarity.frame = dictionary_ANEW)$all


#add this result to the data
sentiment_scores_qdap_default <- data.frame("sentiment" = pol.df_Default$polarity,
                                    "text" = pol.df_Default$text)
#add this result to the data
sentiment_scores_qdap_afinn <- data.frame("sentiment" = pol.df_AFINN$polarity,
                                            "text" = pol.df_AFINN$text)
write.csv(sentiment_scores_qdap, file = "sentiment_qdap.csv", fileEncoding = "utf-8", row.names=FALSE)

