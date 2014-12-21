## run_analysis.R

## This script will download zip file, extract & tidy data producing
## a data table with the average results from the mean and 
## standard deviation results of the measurements observed from all
## subjects doing all activities. The data table will be saved as a .txt
## file in your working directory.

# install packages, libraries, check working diretory and set

install.packages(c("downloader", "dplyr", "tidyr", "stringr"))
library(data.table)
library(plyr)
library(dplyr)
library(tidyr)
library(stringr)
WD <- getwd()
if (!is.null(WD)) setwd(WD)

# download, unzip, and extract raw data

url <- "http://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI HAR Dataset.zip"
require(downloader)
download(url, destfile = "./data.zip", mode = "wb")
unzip("./data.zip", exdir = WD)

# extract data from files

features <- read.table("./UCI HAR Dataset/features.txt", quote="\"")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", quote="\"")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", quote="\"")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", quote="\"")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", quote="\"")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", quote="\"")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", quote="\"")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", quote="\"")

# combine raw data to one data set, extracting mean & std columns

data_X <- data.table(rbind(X_test, X_train))
data_Y <- data.table(rbind(y_test, y_train))
data_Z <- data.table(rbind(subject_test, subject_train))
data_Y <- cbind(data_Z, data_Y)

# name columns and extract means & stds

setnames(data_X, 1:561, as.character(make.names(features$V2, unique = TRUE)))
setnames(data_Y, 1:2, c("subject", "activity"))
data_XM <- select(data_X, contains("mean.."), contains("std.."), -contains("angle."))
data_XY <- cbind(data_Y, data_XM)

# order by subject doing activities and return the mean of activity for that subject 

agmean <- data.table()
for (i in 1:30){
        agsplit <- subset(data_XY, subject == i)
        agtest <- aggregate(agsplit, by=list(agsplit$activity), mean)
        agtest <- agtest[,-1]
        agmean <- rbind(agmean, agtest)
}

# Name, make lower case and remove "_" from activities 
activity_labels$V2 <- tolower(activity_labels$V2) %>%
        str_replace_all("[[:punct:]]", "")
activity <- activity_labels$V2
oldvalues <- c("1", "2", "3", "4", "5", "6")
newvalues <- factor(activity)  # Make this a factor
agmean$activity <- newvalues[ match(agmean$activity, oldvalues) ]

# Name Mean Measurements

columnlist <- colnames(agmean) %>%
        gsub(pattern = "BodyBody", replacement = "Body") %>% #fix double 'Body'
        gsub(pattern = "X", replacement ="on_the_X_axis") %>%
        gsub(pattern = "Y", replacement ="on_the_Y_axis") %>%
        gsub(pattern = "Z", replacement ="on_the_Z_axis") %>%
        gsub(pattern = ".mean...",
             replacement = "Mean_") %>%
        gsub(pattern = ".std...",
             replacement = "Standard_Deviation_of_") %>%
        gsub(pattern = "Mag.mean..",
             replacement = "Mean_Magnitude_of_across_all_axis") %>%
        gsub(pattern = "Mag.std..",
             replacement = "Standard_Deviation_of_Magnitude_of_across_all_axis") %>%
        gsub(pattern = "tBody",
             replacement = "Time_Body_") %>%
        gsub(pattern = "fBody",
             replacement = "Frequency_Domain_of_Body_") %>%
        gsub(pattern = "tGravity",
             replacement = "Time_Gravity_") %>%
        gsub(pattern = "GyroJerk",
             replacement = "Jerked_Gyroscope_") %>%
        gsub(pattern = "AccJerk",
             replacement = "Jerked_") %>%
        gsub(pattern = "_GyroS",
             replacement = "_moved_Gyroscope_S") %>%
        gsub(pattern = "_AccS",
             replacement = "_Accelerated_S") %>%
        gsub(pattern = "_GyroM",
             replacement = "_moved_Gyroscope_M") %>%
        gsub(pattern = "_AccM",
             replacement = "_Accelerated_M")

# Bring "Mean" & "Standard Deviation" to start of Column

quote <- c("Mean_Magnitude_of_", "Standard_Deviation_of_Magnitude_of_",
           "Mean_", "Standard_Deviation_of_")
for (j in 1:4){
for (k in 1:68) {
        report <- as.vector(str_match(columnlist[k], quote[j]))
        torf <- identical(report, quote[j])
        if (torf == TRUE) {
                columnlist[k] <- sub(pattern = quote[j], 
                                     replacement = "", columnlist[k])
                columnlist[k] <- paste(quote[j],
                                       columnlist[k], sep ="")
}}}

# Decapitalise all variables and remove "_" to make variables 'tidy'

columnlist <- tolower(columnlist) %>%
        str_replace_all("[[:punct:]]", "")
        

# put column list back into data.frame "agmean"
        
setnames(agmean, 1:68, columnlist)

# write data.frame(agmean) to .txt file

write.table(agmean, "tidydata.txt", row.names = FALSE)

## End of script: to view data table 
## either view(agmean) or read.table("tidydata.txt")