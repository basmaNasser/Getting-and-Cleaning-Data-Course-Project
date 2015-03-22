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
filteredAD       | concatenated activity list vector of dataset
total_data       | total merged data sets
col_mean_sd      | indexes of features which conatins mean and std 
n                | featured names without brackets
molten           | molten data set to data frame
tidy             | tidy data



## loading data

* Downloads the UCI HAR zip file if it doesn't exist
* Reads the activity labels to `con_activity`
* Reads the column names of data (a.k.a. features) to `features`
* Reads the test `data.frame` to `test_x and test_y`
* Reads the trainning `data.frame` to `test_x and test_y`

## Manipulating data

* Merges test data and trainning data to `total_data`
* Indentifies the mean and std columns (plus Activity and Subject) to `col_mean_sd`
* Summarizes `col_mean_sd` calculating the average for each column for each activity/subject pair to `mean_sd`.
* Transforms the column Activity into a factor.
* Uses `filteredAD` to name levels of Activity factor.

At this point the final data frame `mean_sd` looks like this:

> filteredAD <- cbind(subject,activity,mean_sd)
Activity Subject tBodyAcc.mean...X tBodyAcc.mean...Y tBodyAcc.mean...Z
1  WALKING       1         0.2773308       -0.01738382        -0.1111481
2  WALKING       2         0.2764266       -0.01859492        -0.1055004
3  WALKING       3         0.2755675       -0.01717678        -0.1126749


## Writing final data to CSV

Creates the output dir if it doesn't exist and writes `tidy` data frame to the ouputfile.
