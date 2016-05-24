library("shiny")
library("stringi")
library("sqldf")
library("wordcloud")
library("ggplot2")

load("df_grams.RData")

predictNextWord <- function(x) {
     
     x<- gsub("[^\x20-\x7E]","", x)
     x<- gsub("[[:punct:]]","",tolower(x))
     
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

shinyServer(function(input, output) {

     
     output$pred <- renderText({
          if(input$txt=="Enter some text..."){
               return(" ")
          } else if(trimws(input$txt)==""){
               return("You have to type something to get predictions...")
          }
          else {
                    res <- predictNextWord(input$txt)
                    if (is.vector(res)){
                         return(res)
                    }
                    f <- c("[1]","  [2]","  [3]")
                    return(paste(f[1:length(res$pred)],res$pred))
          }
     })
     
     
     output$plot <- renderPlot({
          
          if(input$txt=="Enter some text..." | trimws(input$txt)==""){
              return(plot.new()) 
          }else {
               res <- predictNextWord(input$txt)
               if(is.vector(res)){
                    return(plot.new())
               }
               
               if(length(res$pred)==1){
                    plotTitle <- "Top 1 Prediction by Frequency"
               } else {
                    plotTitle <- paste("Top",as.character(length(res$pred)),"Predictions by Frequensy",sep=" ")
               }
               
               p <- ggplot(res, aes(reorder(pred, -freq), freq))
               p <- p + geom_bar(stat = "identity")
               p <- p + xlab("Word")
               p <- p + ylab("Frequency")
               p <- p + ggtitle(plotTitle)
               p <- p + theme(axis.text.x=element_text(angle=45, hjust=1,size=15),
                              axis.title.x=element_text(size=15,face="bold"),
                              axis.text.y=element_text(size=15),
                              axis.title.y=element_text(size=15,face="bold"),
                              plot.title=element_text(face="bold", size=23))
               return(p)
          }
          
          
     })
     
})
  

