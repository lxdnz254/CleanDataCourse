Getting and Cleaning Data Course Project
========================================


run_analysis.R file was created using R version 3.1.2

Using platform : x86_64-w64-mingw32/x64 (64-bit)

It uses the packages
* downloader
* plyr
* dplyr
* tidyr
* stringr

the script will download and install latest packages for you.


Download the run_analysis.R file and open in your R console

run_analysis.R will check your working directory and ensure its set
or stop with an error if one is not set.
It will then download and install the packages "downloader", "tidyr",
"stringr", "dplyr", "plyr" and "data.table" for use in this script.

Next it will download the raw data from the internet and save as "data.zip"
in your working directory (file size 59.6MB).

Next it will unpack the raw data into the working folder (269MB req.)

From the raw data the script will then open, sort, fix and transorm the data
to produce a tidy data table holding data showing the average of the mean of
each activity and the average of the standard deviation of each activity as 
performed by each subject.

The tidy data table will be written to the working directory as "tidydata.txt"
using write.table() as the function.

More detail on the scripts used can be found in CodeBook.md

to open the "tidydata.txt" data table use 
```
data <- read.table("tidydata.txt", header = TRUE, row.name = FALSE)
```
A copy of the tidydata.txt file has been left in this repository to match against.
