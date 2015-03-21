library(plyr)
library(reshape2)
setwd('D:/88MA/ebooks/big_data/getting and cleaning data/course project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset')

###1.Merges the training and the test sets to create one data set.

#concatenate all activity list 
train_subject <- read.table("train/subject_train.txt",col.name="subject")
test_subject <- read.table("test/subject_test.txt",col.name="subject")
conc_subject<-rbind(test_subject,train_subject)
#setnames(conc_subject, "V1", "subject")

test_X <- read.table("test/X_test.txt")
train_X <- read.table("train/X_train.txt")
conc_dt <- rbind(test_X,train_X)

#concatenate all activity list 
test_y <- read.table("test/y_test.txt",col.name="activity")
train_y <- read.table("train/y_train.txt",col.name="activity")
conc_activity<-rbind(test_y,train_y)


merge_subject <- cbind(conc_subject,conc_activity)
#merge all data set
total_data <- cbind(merge_subject,conc_dt)

###2.Extracts only the measurements on the mean and standard deviation for each measurement. 

#read features data file
feature <- read.table("features.txt")
setnames(feature,names(feature), c("featureNum", "featureName"))
#dt_feature <- total_data[,col_mean_sd]
#mean_sd <- total_data[dt_feature[,1]]

#get indexes of features which conatins mean and std
col_mean_sd <- grepl("(-std\\(\\)|-mean\\(\\))",feature$featureName)
#get mean and std
mean_sd <- conc_dt[, which(col_mean_sd == TRUE)]


###3.Uses descriptive activity names to name the activities in the data set

#read data file and rename columns
dt_activity <- read.table("activity_labels.txt",col.names=c("activityID","ActivityName"))

# transform the activity list from integer codes to factors
activity <- as.factor(conc_activity$activity)
# transform the label factors into a vector of human readable activity descriptions
levels(activity) <- dt_activity$ActivityName
# transform the subject codes to factors.
subject <- as.factor(conc_subject$subject)

# concatenate as activity list vector to the dataset
filteredAD <- cbind(subject,activity,mean_sd)

##4. Appropriately labels the data set with descriptive variable names.

#get activity names
n <- feature[which(col_mean_sd == TRUE) ,][[2]]

#function to replace brackets with empty string
remove_brackets <- function(n) {
        tolower(gsub("(\\(|\\)|\\-)","",n))
}
#remove brackets from activity names
n <- sapply(n,remove_brackets)
names(filteredAD)[3:ncol(filteredAD)] <- n

###5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

write.table( filteredAD,file= "dataset_1.txt",row.name=FALSE,sep = '\t')

# create the molten data set to data frame
molten <- melt(filteredAD,id.vars=c("subject","activity"))
# create tidy data set 
tidy <- dcast(molten,subject + activity ~ variable,mean)
# write the dataset to a file
write.table(tidy, "tidy_data.txt",row.name=FALSE,sep="\t")

