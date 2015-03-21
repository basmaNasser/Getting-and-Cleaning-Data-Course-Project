---
author: "Basma Nasser"
date: "Saturday, March 21, 2015"
output: html_document
---
# Getting and Cleaning Data Course Project

The Course Project uses data from this URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

To reproduce the steps described below, and to use the run_analysis.R file, you need to download the
above zip file, decompress the file, and have the run_analysis.R file in the top level folder of the unzipped package.  

## Overall Process

the attached R script "run_analysis.R"" does the following. 

   1. Merges the training and the test sets to create one data set.
   2. Extracts only the measurements on the mean and standard deviation for each measurement. 
   3. Uses descriptive activity names to name the activities in the data set
   4. Appropriately labels the data set with descriptive variable names. 
   5. From the data set in step 4, creates a second, independent tidy data set with the average of each          variable for each activity and each subject.


The above steps will be accomplished via the process described below. 
you have to check codebook, and the full comments in the script file.

### 1. Merge training and test sets to create one data set.

1.1.read the data, label set, and subjects files for the test data and train data and rename each coulmn.

```
#subject
train_subject <- read.table("train/subject_train.txt",col.name="subject")
test_subject <- read.table("test/subject_test.txt",col.name="subject") 

#activity label
test_y <- read.table("test/y_test.txt",col.name="activity")
train_y <- read.table("train/y_train.txt",col.name="activity")

#data
test_X <- read.table("test/X_test.txt")
train_X <- read.table("train/X_train.txt")
```

1.2.merge the two raw data tables together. Also, the activity label codes and subject.
```
conc_subject<-rbind(test_subject,train_subject)
conc_dt <- rbind(test_X,train_X)
conc_activity<-rbind(test_y,train_y)
```

### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

2.1. read the feature names  from the features.txt file and rename column names.  
```
feature <- read.table("features.txt")
setnames(feature,names(feature), c("featureNum", "featureName"))
```
2.2. used grep transformation on all the features that are either standard deviations or means of measurements. from measures can that names have containing either a "-std()" or "-mean()" text string within the original feature names.
```
col_mean_sd <- grepl("(-std\\(\\)|-mean\\(\\))",feature$featureName)
```
2.3. remove columns that are not means or standard deviation features, based on the list identified above.
```
mean_sd <- conc_dt[, which(col_mean_sd == TRUE)]
```

### 3. Uses descriptive activity names to name the activities in the data set.

3.1.read the set of activity labels from the activity_labels.txt file, then convert label codes to a factor that can be then transformed into a text string. 
```
dt_activity <- read.table("activity_labels.txt",col.names=c("activityID","ActivityName"))
activity <- as.factor(conc_activity$activity)
levels(activity) <- dt_activity$ActivityName

```
3.2.transform the subject codes to factors.
```
subject <- as.factor(conc_subject$subject)

```
3.4. bind the subject and activity to the filteredAD dataset.
```
filteredAD <- cbind(subject,activity,mean_sd)

```

### 4. Appropriately label the data set with descriptive variable names. 

4.1. clean the mean and standard deviation feature names from hyphens and parentheses, and then attached as column names to the data set.I have used "col_mean_sd" true/false vector is used to capture the names of all the mean and standard deviation features.
```
n <- feature[which(col_mean_sd == TRUE) ,][[2]]

```

4.2.create new function to remove brackets and hyphens using  gsub regular expression replacement and make lower case names.Apply remove_brackets function to sapply to all desired featurenames.

```
remove_brackets <- function(n) {
        tolower(gsub("(\\(|\\)|\\-)","",n))
}

n <- sapply(n,remove_brackets)

```

4.4. add the feature names to the filteredAD set. The first column name is skipped, since it already has a name, provided in step 3 above.Data written to new .txt file using write.table().
```
names(filteredAD)[3:ncol(filteredAD)] <- n

write.table( filteredAD,file= "dataset_1.txt",row.name=FALSE,sep = '\t')
```


### 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

5.1.Using the reshape2 library, use the melt function to collapse the filteredAD dataframe.then use the dcast function to collapse the molten set into a new 
collapsed and tidy data frame. then write data to new .txt file "tidy_data.txt" using write.data() function with row.name = FALSE

```

molten <- melt(filteredAD,id.vars=c("subject","activity"))
tidy <- dcast(molten,subject + activity ~ variable,mean)
write.table(tidy, "tidy_data.txt",row.name=FALSE,sep="\t")
```


