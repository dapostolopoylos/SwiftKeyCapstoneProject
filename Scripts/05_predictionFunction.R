# This is the fuction that makes the word prediction.
# At first the input gets cleansed and then it is splitted to words.
# According to the length of the senetences is chosen a different ngram model 
# to use for prediction. The main idea is that the process starts searching for
# matches in the "biggest" ngram and if it doesn't find anything relevant it backs
# off to the next bigger ngram. If the process detects matches it outputs the top three 
# most frequent predictions else it outputs a relevant message.

predictNextWord <- function(x) {
 
     library("stringi")
     library("sqldf")
     
     load("./data/df_grams.RData")
     
     removeNonASCII <- function(x) {
          gsub("[^\x20-\x7E]","", x)
     } 
     
     x<-removeNonASCII(x)
     x<-gsub("[[:punct:]]","",tolower(x))
     
     
     sentence <- unlist(stri_split_regex(x,"\\s", omit_empty = TRUE))
     
     if (length(sentence)>=3){
          
          sub4 <- data.frame(t(sentence[(length(sentence)-2):length(sentence)]))
          
          colnames(sub4) <- c("w1","w2","w3")
          
          sub3 <- data.frame(t(sentence[(length(sentence)-1):length(sentence)]))
          colnames(sub3) <- c("w1","w2")
          
          sub2 <- data.frame(t(sentence[length(sentence):length(sentence)]))
          colnames(sub2) <- "w1"
          
          predictions <- sqldf("select 
                                   df_four.* 
                                from 
                                   df_four 
                                   inner join sub4 
                                   on df_four.w1 = sub4.w1 
                                        and 
                                      df_four.w2 = sub4.w2 
                                        and 
                                      df_four.w3 = sub4.w3")
          
          if(nrow(predictions)==0){
               predictions <- sqldf("select 
                                        df_three.* 
                                     from 
                                        df_three 
                                        inner join sub3 
                                        on df_three.w1 = sub3.w1 
                                             and 
                                           df_three.w2 = sub3.w2") 
          }
          
          if(nrow(predictions)==0){
               predictions <- sqldf("select 
                                        df_two.* 
                                     from 
                                        df_two 
                                        inner join sub2 
                                        on df_two.w1 = sub2.w1") 
          }
          
          res <- head(subset(predictions,select=c(pred,freq)),3)
          res$pred <- as.character(res$pred)
          
     } else if(length(sentence)==2){
          sub3 <- data.frame(t(sentence[(length(sentence)-2):length(sentence)]))
          colnames(sub3) <- c("w1","w2")
          
          sub2 <- data.frame(t(sentence[(length(sentence)-1):length(sentence)]))
          colnames(sub2) <- c("w1")
          
          predictions <- sqldf("select 
                                   df_three.* 
                                from 
                                   df_three 
                                   inner join sub3 
                                   on df_three.w1 = sub3.w1 
                                        and 
                                      df_three.w2 = sub3.w2") 
          
          if(nrow(predictions)==0){
               predictions <- sqldf("select 
                                        df_two.* 
                                     from 
                                        df_two 
                                        inner join sub2 
                                        on df_two.w1 = sub2.w1") 
          }
          
          res <- head(subset(predictions,select=c(pred,freq)),3)
          res$pred <- as.character(res$pred)
          
     } else if(length(sentence)==1){
          
          sub2 <- data.frame(t(sentence[(length(sentence)-1):length(sentence)]))
          colnames(sub2) <- "w1"
          
          predictions <- sqldf("select 
                                   df_two.* 
                                from 
                                   df_two 
                                   inner join sub2 
                                   on df_two.w1 = sub2.w1") 
          
          res <- head(subset(predictions,select=c(pred,freq)),3)
          res$pred <- as.character(res$pred)
          
     } else {
          
          return("You have to type at least one word.")
     }
     
     if (nrow(res)==0){
          return("I am sorry, no predictions this time...")
     } else {
          return(res)
     }     
     
}

