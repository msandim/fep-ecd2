library(qdap)
library(data.table)

sentimentQdap <- function(data, stem)
{
  #http://www.r-bloggers.com/statistics-meets-rhetoric-a-text-analysis-of-i-have-a-dream-in-r/
  dictionary_AFINN <- read.csv("csv_data/AFINN-111.txt", stringsAsFactors = FALSE, header=FALSE, sep="\t")
  
  pol.df_Default <- polarity(original_data$text)$all
  pol.df_AFINN <- polarity(original_data$text, polarity.frame = dictionary_AFINN)$all
  
  #add this result to the data
  sentiment_scores_qdap_default <- data.frame("score" = pol.df_Default$polarity,
                                              "text" = pol.df_Default$text)
  #add this result to the data
  sentiment_scores_qdap_afinn <- data.frame("score" = pol.df_AFINN$polarity,
                                            "text" = pol.df_AFINN$text)
  
  # Build filenames:
  if (stem)
  {
    defaultFileName <- "csv_data/sentiment_qdap_default_stemming.csv"
    afinnFileName <- "csv_data/sentiment_qdap_afinn_stemming.csv"    
  }
  else
  {
    defaultFileName <- "csv_data/sentiment_qdap_default.csv"
    afinnFileName <- "csv_data/sentiment_qdap_afinn.csv"
  }
  
  write.csv(sentiment_scores_qdap_default, file = defaultFileName, row.names=FALSE)
  write.csv(sentiment_scores_qdap_afinn, file = afinnFileName, row.names=FALSE)
}

sentimentQdap(original_data, stem = FALSE)
sentimentQdap(original_data_stemming, stem = TRUE)