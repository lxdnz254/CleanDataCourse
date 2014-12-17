
CleanDataCourse
===============

Getting and Cleaning Data Course Project
----------------------------------------

Download the run_analysis.R file and open in your R console

Run_analysis.R will check your working directory and ensure its set
or stop with an error if one is not set.
It will then download and install the packages "downloader", "tidyr",
"stringr", "dplyr", & "plyr" for use in this script.
Next it will download the raw data from the internet and save as "data.zip"
in your working directory (file size 59.6MB)
Next it will unpack the raw data into the working folder (269MB req.)

From the raw data the script will then open, sort, fix and transorm the data
to produce a tidy data table holding data showing the average of the mean of
each activity and the average of the standard deviation of each activity as 
performed by each subject.

The tidy data table will be written to the working directory as "tidydata.txt"
using write.table() as the function.

