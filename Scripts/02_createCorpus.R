# Get the directory where the script that is executed is located 
# and set it as working directory
script.dir <- dirname(sys.frame(1)$ofile)

setwd(script.dir)

# Create equal size samples from each file in order to create the corpus.
con <- file("./data/final/en_US/en_US.twitter.txt", "rb")
twitter <- readLines(con,skipNul = TRUE ,warn = FALSE, encoding = "UTF-8")
close(con)

sampleTwitter <- sample(twitter,100000,replace=FALSE)

con <- file("./data/final/en_US/en_US.blogs.txt", "rb")
blogs <- readLines(con,skipNul = TRUE, warn = FALSE)
close(con)

sampleBlogs <- sample(blogs,100000,replace=FALSE)

con <- file("./data/final/en_US/en_US.news.txt", "rb")
news <- readLines(con,skipNul = TRUE, warn = FALSE)
close(con)

sampleNews <- sample(news,100000,replace=FALSE)

if(!dir.exists("./data/final/en_US/sample")){
     dir.create("./data/final/en_US/sample")
}

fileConn<-file("./data/final/en_US/sample/twitter.txt")
writeLines(sampleTwitter, fileConn)
close(fileConn)

fileConn<-file("./data/final/en_US/sample/news.txt")
writeLines(sampleNews, fileConn)
close(fileConn)

fileConn<-file("./data/final/en_US/sample/blogs.txt")
writeLines(sampleBlogs, fileConn)
close(fileConn)

rm(list=ls(all=TRUE))

library(tm)
library(SnowballC)

repo <- "./data/final/en_US/sample"

# Use a profanity words list in order to clean the corpus from offensive words.
# https://github.com/shutterstock/List-of-Dirty-Naughty-Obscene-and-Otherwise-Bad-Words
con <- file("./data/profanity.txt", "rb")
profanity <- readLines(con,skipNul = TRUE, warn = FALSE)
close(con)

myCorpus <- VCorpus(
                     DirSource(repo, pattern = 'txt', encoding = 'UTF-8'),
                     readerControl = list(language = 'en')
                     )

# Custom function used for removing non ASCII characters.
removeNonASCII <- content_transformer(function(x)
     gsub("[^\x20-\x7E]","", x))

# Custom function used for removing urls.
removeURLs <- content_transformer(function(x)
     gsub("(f|ht)tp(s?):(\\s*?)//(.*)[.][a-z]+(/?)", "", x))


# Data cleansing
myCorpus <- tm_map(myCorpus, removeNonASCII)
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
myCorpus <- tm_map(myCorpus, removeURLs)
myCorpus <- tm_map(myCorpus, removePunctuation)
myCorpus <- tm_map(myCorpus, removeNumbers)
myCorpus <- tm_map(myCorpus, stripWhitespace)
myCorpus <- tm_map(myCorpus, removeWords, profanity)

save(myCorpus,file="./data/corpus.RData")

rm(list=ls(all=TRUE))

gc()
