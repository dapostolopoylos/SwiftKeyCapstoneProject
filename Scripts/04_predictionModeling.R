# Use 4GB of RAM memory for RWeka package.
options(java.parameters = "-Xmx4g" )

# Get the directory where the script that is executed is located 
# and set it as working directory
script.dir <- dirname(sys.frame(1)$ofile)

setwd(script.dir)

load("./data/ngrams.RData")

# Create data frames with splitted sentences from the ngrams in order to use 
# then in the prediction algorithm.

library(stringi)
library(e1071)

df_two<- cbind(do.call(rbind.data.frame,stri_split_regex(two_words$word,"\\s", omit_empty = TRUE)),two_words$freq)
colnames(df_two)<-c("w1","pred","freq")
rm(two_words)

df_three<- cbind(do.call(rbind.data.frame,stri_split_regex(three_words$word,"\\s", omit_empty = TRUE)),three_words$freq)
colnames(df_three)<-c("w1","w2","pred","freq")
rm(three_words)

df_four<- cbind(do.call(rbind.data.frame,stri_split_regex(four_words$word,"\\s", omit_empty = TRUE)),four_words$freq)
colnames(df_four)<-c("w1","w2","w3","pred","freq")
rm(four_words)

save(df_two,df_three,df_four,file="./data/df_grams.RData")

rm(list=ls(all=TRUE))

gc()
