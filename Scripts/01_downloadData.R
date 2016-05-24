# Get the directory where the script that is executed is located 
# and set it as working directory
script.dir <- dirname(sys.frame(1)$ofile)

setwd(script.dir)

library(downloader)
suppressMessages(library(sqldf))

url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"


if(!file.exists("./data/Coursera-SwiftKey.zip")){
     setwd("./data")
     download(url, dest="Coursera-SwiftKey.zip", mode="wb")
}

if (getwd() != paste(script.dir,"data",sep="/")){
     setwd(paste(script.dir,"data",sep="/"))
}

txtFiles <- unzip("Coursera-SwiftKey.zip",list=TRUE)
txtFiles <- as.vector(t(sqldf("select Name from txtFiles where Name LIKE ('final/en_US/en%')")))

if(!dir.exists("./data/final")){
     unzip("Coursera-SwiftKey.zip",files=txtFiles,overwrite = TRUE)     
} else {
     for(txtFile in txtFiles){
          if(!file.exists(txtFile)){
               unzip("Coursera-SwiftKey.zip",files=txtFile,overwrite = TRUE) 
          }
     }
}

rm(list=ls(all=TRUE))

gc()
