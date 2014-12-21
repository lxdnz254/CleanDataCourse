# CodeBook for data table contained in "tidydata.txt"


This code book is divided into 3 sections

* 1. Study Design
* 2. Summary choices
* 3. Codebook

Study design will explain how the raw data was collected, compiled and tidied.
Summary choices will detail the final output summary and how we came to arrive there.
Codebook will list the variables in the data table and give a description of them.

## 1. Study Design
 

Using the run_analysis.R script the data is downloaded from its storage location 
on the internet.
```
url <- "http://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI HAR Dataset.zip"
require(downloader)
download(url, destfile = "./data.zip", mode = "wb")
```

This file is unzipped and the files "features.txt"", "X_test.txt", "y_test.txt"", "X_train.txt", "y_train.txt", "activity_labels.txt", "subject_train.txt", & "subject_test.txt" are opened as data tables and merged together
