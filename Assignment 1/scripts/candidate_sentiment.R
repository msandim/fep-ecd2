include(ggplot2)

##############################################
#discover the sentiments for each candidate
##############################################

#merge our predicted result with the original pre-processed data
final_dataframe <- cbind(original_data, sentiment_scores_qdap_default$sentiment)
names(final_dataframe)[9]<-paste("classification")

#calculate the sentiment frequencies for each candidate
frequencies <- table(final_dataframe$candidate, final_dataframe$classification)

#calculate the relative frequencies for each candidate
frequencies <- frequencies/(frequencies[,1] + frequencies[,2])

#manipulate the result to use with ggplot
freq_dataframe <- as.data.frame(frequencies)
freq_dataframe <- freq_dataframe[-c(1,9,13,21),]
names(freq_dataframe)[1]<-paste("candidate")
names(freq_dataframe)[2]<-paste("sentiment")
names(freq_dataframe)[3]<-paste("freq")

ggplot(data=freq_dataframe, aes(x=candidate, y=freq, fill=sentiment)) +
  geom_bar(stat="identity")
