Code Book
=========
This document describes the code inside `run_analysis.R`.

The code is splitted (by comments) in some sections:
        
* clean function
* Variable list and descriptions
* loading data
* Manipulating data
* Writing final data to txt

Variable list and descriptions
------------------------------
Variable name    | Description
-----------------|------------
subject          | ID the subject who performed the activity for each window sample. Its range is from 1 to 30.
activity         | Activity name
con_subject      | all subjects in data sets
con_dt           | all data in both data sets
con_activity     | all data set activities
mean_sd          | mean and SD of all activities
filteredAD       |
train_subject    |
test_subject     | 
test_X           |
train_X          |
test_y           |
train_y          |
total_data       |
feature          |
col_mean_sd      | 
dt_activity      |
n                | featured names without brackets
molten           |
tidy             | tidy data



## Downloading and loading data

* Downloads the UCI HAR zip file if it doesn't exist
* Reads the activity labels to `activityLabels`
* Reads the column names of data (a.k.a. features) to `features`
* Reads the test `data.frame` to `testData`
* Reads the trainning `data.frame` to `trainningData`

## Manipulating data

* Merges test data and trainning data to `allData`
* Indentifies the mean and std columns (plus Activity and Subject) to `meanAndStdCols`
* Extracts a new `data.frame` (called `meanAndStdData`) with only those columns from `meanAndStdCols`.
* Summarizes `meanAndStdData` calculating the average for each column for each activity/subject pair to `meanAndStdAverages`.
* Transforms the column Activity into a factor.
* Uses `activityLabels` to name levels of Activity factor.

At this point the final data frame `meanAndStdAverages` looks like this:

> head(meanAndStdAverages[, 1:5], n=3)
Activity Subject tBodyAcc.mean...X tBodyAcc.mean...Y tBodyAcc.mean...Z
1  WALKING       1         0.2773308       -0.01738382        -0.1111481
2  WALKING       2         0.2764266       -0.01859492        -0.1055004
3  WALKING       3         0.2755675       -0.01717678        -0.1126749


## Writing final data to CSV

Creates the output dir if it doesn't exist and writes `meanAndStdAverages` data frame to the ouputfile.
