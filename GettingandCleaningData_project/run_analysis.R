library(dplyr)

#set working directory
setwd("~/git/datasciencecoursera/GettingandCleaningData_project")

#download and unzip the dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "dataset.zip", method = "curl")
unzip("dataset.zip", list = FALSE, overwrite = TRUE)

#read "features.txt" as column names later
cols <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = F)

#read and merge X txt (561 features), then assign column names
test <- read.table("UCI HAR Dataset/test/X_test.txt", sep = "", stringsAsFactors = F)
train <- read.table("UCI HAR Dataset/train/X_train.txt", sep = "", stringsAsFactors = F)
data <- rbind(test, train)
names(data) <- cols$V2
rm(cols, test, train)

#read and merge Y txt (activity code), assign variable name as "activity"
act_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
act_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
activity <- rbind(act_test, act_train)
names(activity) <- "activity"
rm(act_test, act_train)

#read and merge subject txt (volunteer id), assign variable name as "volunteer_id"
id_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
id_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
id <- rbind(id_test,id_train)
names(id) <- "volunteer_id"
rm(id_test,id_train)

#merge id and activity together with main features data
data <- cbind(id, activity, data)

#extracts only the measurements on the mean and standard deviation
#dplyr::select(contains) doesn't work probably because of the invalid charactors in the column names 
data <- data[, c(1, 2, grep("mean", colnames(data)), grep("std", colnames(data)))]

#arrange data by id and activity code
data <- arrange(data, volunteer_id, activity)

#use descriptive activity names to name the activities in the data set
act_label <- read.table("UCI HAR Dataset/activity_labels.txt", sep = "", stringsAsFactors = F)
for (i in 1:length(act_label$V1)) {
        data[data$activity==i,]$activity <- act_label$V2[i]
}

#generate csv file called "all_mean_and_std.csv"
write.table(data, "all_mean_and_std.csv", sep = ",", row.names = F)

#aggregate the average of each variable for each activity and each subject
data <- group_by(data, volunteer_id, activity)
data <- summarise_each(data, funs(mean))

#generate TXT file of the final tidy data set
write.table(data, "tidy_data.csv", sep = ",", row.names = F)