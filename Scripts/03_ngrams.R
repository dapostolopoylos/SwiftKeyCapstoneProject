# Use 4GB of RAM memory for RWeka package.
options(java.parameters = "-Xmx4g" )

# Get the directory where the script that is executed is located 
# and set it as working directory
script.dir <- dirname(sys.frame(1)$ofile)

setwd(script.dir)

load("./data/corpus.RData")

library("RWeka")
library("tm")

# Do some tokenization. Create tokens, frequency tables and ngrams data sets, filter 
# by mean(freq) of every token.
BigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 2, max = 2))
TrigramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 3, max = 3))
QuadgramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))

token2 <- DocumentTermMatrix(myCorpus,control = list(weighting = weightTf,tokenize = BigramTokenizer))

token3 <- DocumentTermMatrix(myCorpus,control = list(weighting = weightTf,tokenize = TrigramTokenizer))

token4 <- DocumentTermMatrix(myCorpus,control = list(weighting = weightTf,tokenize = QuadgramTokenizer))

token2freq <-sort(colSums(as.matrix(token2)),decreasing = TRUE)
two_words <- data.frame(word = names(token2freq), freq = token2freq)
rownames(two_words) <- NULL
two_words <- subset(two_words,freq > floor(mean(two_words$freq)))

token3freq <-  sort(colSums(as.matrix(token3)),decreasing = TRUE)
three_words <- data.frame(word = names(token3freq), freq = token3freq)
rownames(three_words) <- NULL
three_words <- subset(three_words,freq > floor(mean(three_words$freq)))

token4freq <-  sort(colSums(as.matrix(token4)),decreasing = TRUE)
four_words <- data.frame(word = names(token4freq), freq = token4freq)
rownames(four_words) <- NULL
four_words <- subset(four_words,freq > floor(mean(four_words$freq)))

save(four_words,three_words,two_words,file="./data/ngrams.RData")

rm(list=ls(all=TRUE))

gc()
