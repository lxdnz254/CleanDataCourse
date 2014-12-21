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

This file is unzipped and the files "features.txt"", "X_test.txt", "y_test.txt"", "X_train.txt", "y_train.txt", "activity_labels.txt", "subject_train.txt", & "subject_test.txt" are opened as data tables and merged together, extracting the mean and standard deviation variables as we go
```
data_X <- data.table(rbind(X_test, X_train))
data_Y <- data.table(rbind(y_test, y_train))
data_Z <- data.table(rbind(subject_test, subject_train))
data_Y <- cbind(data_Z, data_Y)

# name columns and extract means & stds

setnames(data_X, 1:561, as.character(make.names(features$V2, unique = TRUE)))
setnames(data_Y, 1:2, c("subject", "activity"))
data_XM <- select(data_X, contains("mean.."), contains("std.."), -contains("angle."))
data_XY <- cbind(data_Y, data_XM)
```
The data table "data_XY" contains the mean and standard deviation variables from the raw data of every observation performed from each subject doing every activity.

## 2. Summary choices

As outlined in the course project instructions step 5 results in producing a tidy data set that contains the average of each variable for each subject and each activity.
This was obtained by.

1 - Subsetting the mean and standard devitation variables from the raw data.
```
data_XM <- select(data_X, contains("mean.."), contains("std.."), -contains("angle."))
```

2 - Then subsetting the resulting data into subject groups and obtaining the mean of each activity.
```
agmean <- group_by(data_XY, subject, activity) %>%
        summarise_each(funs(mean))
```

To complete the summary and tidy the data run_analysis also performs a removal of "_" from the variables and puts all variables into lower case
```
columnlist <- tolower(columnlist) %>%
        str_replace_all("[[:punct:]]", "")
```
it also performs this on the activity labels
```
activity_labels$V2 <- tolower(activity_labels$V2) %>%
        str_replace_all("[[:punct:]]", "")
```

it also replaces the values in the activity column with their approriate label as obtained from the data.table "activity_labels.txt"
```
activity <- activity_labels$V2
oldvalues <- c("1", "2", "3", "4", "5", "6")
newvalues <- factor(activity)  # Make this a factor
data_XY$activity <- newvalues[ match(data_XY$activity, oldvalues) ]
```

To make the variables human readable various gsub routines were placed on the coloumn name variables based on their raw data name to come up with a readable character string
e.g.
```
gsub(pattern = "Z", replacement ="on_the_Z_axis") %>%
        gsub(pattern = ".mean...",
             replacement = "Mean_") %>%
```

The final result is saved in the working directory as "tidydata.txt"
```
write.table(agmean, "tidydata.txt", row.names = FALSE)
```

## 3. Codebook

The following is a list of all variables in the "tidydata.txt" data.table. As the results are averages of means or standard deviations, all numeric values are normalized and no longer have units to measure with. 

For more information on how the raw data figures were obtained see the features_info.txt and README.txt files contained in the data.zip file

1. subject <- the numeral identifying which subject performed activity

2. activity <- the activity subject was doing

3. meantimebodyacceleratedonthexaxis <- the average of the mean amount of time of total acceleration on the x axis

4. meantimebodyacceleratedontheyaxis <- the average of the mean amount of time of total acceleration on the y axis

5. meantimebodyacceleratedonthezaxis <- the average of the mean amount of time of total acceleration on the z axis

6. meantimegravityacceleratedonthexaxis <- the average of the mean amount of time, with gravity removed acceleration on the x axis

7. meantimegravityacceleratedontheyaxis <- the average of the mean amount of time, with gravity removed acceleration on the y axis

8. meantimegravityacceleratedonthezaxis <- the average of the mean amount of time, with gravity removed acceleration on the z axis

9. meantimebodyjerkedonthexaxis <- the average of the mean time the smartphone accelerometer was jerked on the x axis

10. meantimebodyjerkedontheyaxis <- the average of the mean time the smartphone accelerometer jerked on the y axis

11. meantimebodyjerkedonthezaxis <- the average of the mean time the smartphone accelerometer jerked on the z axis

12. meantimebodymovedgyroscopeonthexaxis <- the average of the mean time the gyroscope moved on x axis

13. meantimebodymovedgyroscopeontheyaxis <- the average of the mean time the gyroscope moved on y axis

14. meantimebodymovedgyroscopeonthezaxis <- the average of the mean time the gyroscope moved on z axis

15. meantimebodyjerkedgyroscopeonthexaxis <- the average of the mean time the gyroscope was jerked on the x axis

16. meantimebodyjerkedgyroscopeontheyaxis <- the average of the mean time the gyroscope was jerked on the y axis

17. meantimebodyjerkedgyroscopeonthezaxis <- the average of the mean time the gyroscope was jerked on the z axis

18. meanmagnitudeoftimebodyacceleratedacrossallaxis <- the average of the mean magnitude of time of total acceleration in any direction

19. meanmagnitudeoftimegravityacceleratedacrossallaxis <- the average of the mean magnitude of time, with gravity removed acceleration in any direction

20. meanmagnitudeoftimebodyjerkedacrossallaxis <- the average of the mean magnitude of time the smartphone was jerked in any direction

21. meanmagnitudeoftimebodymovedgyroscopeacrossallaxis <- the average of the mean magnitude of time the gyroscope moved in any direction

22. meanmagnitudeoftimebodyjerkedgyroscopeacrossallaxis <- the average of the mean magnitude of time the gyroscope was jerked in any direction

23. meanfrequencydomainofbodyacceleratedonthexaxis <- the average of the mean frequency domain of total acceleration on the x axis

24. meanfrequencydomainofbodyacceleratedontheyaxis <- the average of the mean frequency domain of total acceleration on the y axis

25. meanfrequencydomainofbodyacceleratedonthezaxis <- the average of the mean frequency domain of total acceleration on the z axis

26. meanfrequencydomainofbodyjerkedonthexaxis <- the average of the mean frequency domain of total acceleration jerks on the x axis

27. meanfrequencydomainofbodyjerkedontheyaxis <- the average of the mean frequency domain of total acceleration jerks on the y axis

28. meanfrequencydomainofbodyjerkedonthezaxis <- the average of the mean frequency domain of total acceleration jerks on the z axis

29. meanfrequencydomainofbodymovedgyroscopeonthexaxis <- the average of the mean frequency domain of gyroscope movement on the x axis

30. meanfrequencydomainofbodymovedgyroscopeontheyaxis <- the average of the mean frequency domain of gyroscope movement on the y axis

31. meanfrequencydomainofbodymovedgyroscopeonthezaxis <- the average of the mean frequency domain of gyroscope movement on the z axis

32. meanmagnitudeoffrequencydomainofbodyacceleratedacrossallaxis <- the average of the mean magnitude of the frequency domain of total acceleration in any direction

33. meanmagnitudeoffrequencydomainofbodyjerkedacrossallaxis <- the average of the mean magnitude of the frequency domain of total acceleration jerks in any direction

34. meanmagnitudeoffrequencydomainofbodymovedgyroscopeacrossallaxis <- the average of the mean magnitude of the frequency domain of the gyroscope moving in any direction

35. meanmagnitudeoffrequencydomainofbodyjerkedgyroscopeacrossallaxis <- the average of the mean magnitude of the frequency domain of the gyroscope jerking in any direction

36. standarddeviationoftimebodyacceleratedonthexaxis <- the average of the standard deviation of the time of total acceleration on the x axis

37. standarddeviationoftimebodyacceleratedontheyaxis <- the average of the standard deviation of the time of total acceleration on the y axis

38. standarddeviationoftimebodyacceleratedonthezaxis <- the average of the standard deviation of the time of total acceleration on the z axis

39. standarddeviationoftimegravityacceleratedonthexaxis <- the average of the standard deviation of the time of acceleration with gravity removed on the x axis

40. standarddeviationoftimegravityacceleratedontheyaxis <- the average of the standard deviation of the time of acceleration with gravity removed on the y axis

41. standarddeviationoftimegravityacceleratedonthezaxis <- the average of the standard deviation of the time of acceleration with gravity removed on the z axis

42. standarddeviationoftimebodyjerkedonthexaxis <- the average of the standard deviation of the time of acceleration jerks on the x axis

43. standarddeviationoftimebodyjerkedontheyaxis <- the average of the standard deviation of the time of acceleration jerks on the y axis

44. standarddeviationoftimebodyjerkedonthezaxis <- the average of the standard deviation of the time of acceleration jerks on the z axis

45. standarddeviationoftimebodymovedgyroscopeonthexaxis <- the average of the standard deviation of the time of the gyroscope moving on the x axis

46. standarddeviationoftimebodymovedgyroscopeontheyaxis <- the average of the standard deviation of the time of the gyroscope moving on the y axis

47. standarddeviationoftimebodymovedgyroscopeonthezaxis <- the average of the standard deviation of the time of the gyroscope moving on the z axis

48. standarddeviationoftimebodyjerkedgyroscopeonthexaxis <- the average of the standard deviation of the time of the gyroscope jerking on the on the x axis

49. standarddeviationoftimebodyjerkedgyroscopeontheyaxis <- the average of the standard deviation of the time of the gyroscope jerking on the y axis

50. standarddeviationoftimebodyjerkedgyroscopeonthezaxis <- the average of the standard deviation of the time of the gyroscope jerking on the z axis

51. standarddeviationofmagnitudeoftimebodyacceleratedacrossallaxis <- the average of the standard deviation of magnitude of the time of total acceleration in any direction

52. standarddeviationofmagnitudeoftimegravityacceleratedacrossallaxis <- the average of the standard deviation of magnitude of the time of acceleration with gravity removed in any direction

53. standarddeviationofmagnitudeoftimebodyjerkedacrossallaxis <- the average of the standard deviation of magnitude of the time of acceleration that was jerked in any direction

54. standarddeviationofmagnitudeoftimebodymovedgyroscopeacrossallaxis <- the average of the standard deviation of magnitude of the time of the gyroscope moving in any direction

55. standarddeviationofmagnitudeoftimebodyjerkedgyroscopeacrossallaxis <- the average of the standard deviation of magnitude of the time of the gyroscope jerking in any direction

56. standarddeviationoffrequencydomainofbodyacceleratedonthexaxis <- the average of the standard deviation of the frequency domain of total acceleration on the x axis

57. standarddeviationoffrequencydomainofbodyacceleratedontheyaxis <- the average of the standard deviation of the frequency domain of total acceleration on the y axis

58. standarddeviationoffrequencydomainofbodyacceleratedonthezaxis <- the average of the standard deviation of the frequency domain of total acceleration on the z axis

59. standarddeviationoffrequencydomainofbodyjerkedonthexaxis <- the average of the standard deviation of the frequency domain of acceleration jerks on the x axis

60. standarddeviationoffrequencydomainofbodyjerkedontheyaxis <- the average of the standard deviation of the frequency domain of acceleration jerks on the y axis

61. standarddeviationoffrequencydomainofbodyjerkedonthezaxis <- the average of the standard deviation of the frequency domain of acceleration jerks on the z axis

62. standarddeviationoffrequencydomainofbodymovedgyroscopeonthexaxis <- the average of the standard deviation of the frequency domain of the gyrocope moving on the x axis

63. standarddeviationoffrequencydomainofbodymovedgyroscopeontheyaxis <- the average of the standard deviation of the frequency domain of the gyroscope moving on the y axis

64. standarddeviationoffrequencydomainofbodymovedgyroscopeonthezaxis <- the average of the standard deviation of the frequency domain of the gyroscope moving on the z axis

65. standarddeviationofmagnitudeoffrequencydomainofbodyacceleratedacrossallaxis <- the average of the standard deviation of magnitude of the frequency domain of total acceleration in any direction

66. standarddeviationofmagnitudeoffrequencydomainofbodyjerkedacrossallaxis <- the average of the standard deviation of magnitude of the frequency domain of acceleration jerks in any direction

67. standarddeviationofmagnitudeoffrequencydomainofbodymovedgyroscopeacrossallaxis <- the average of the standard deviation of magnitude of the frequency domain of the gyroscope moving in any direction

68. standarddeviationofmagnitudeoffrequencydomainofbodyjerkedgyroscopeacrossallaxis <- the average of the standard deviation of magnitude of the frequency domain of the gyroscope jerking in any direction

