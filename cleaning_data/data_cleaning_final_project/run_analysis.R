library(data.table)
library(dplyr)

#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
#              destfile = "/Users/raphael/coursera-repo/cleaning_data/zipped_data", 
#              method = "curl")
#unzip(zipfile="/Users/raphael/coursera-repo/cleaning_data/zipped_data",
#      exdir="/Users/raphael/coursera-repo/cleaning_data")

pathdata = file.path("/Users/raphael/coursera-repo/cleaning_data", "UCI HAR Dataset")
files = list.files(pathdata, recursive = TRUE)

#Files do be analyzed

#Reading the training tables
xtrain <- read.table(file.path(pathdata, "train", "X_train.txt"), header = FALSE)
ytrain <- read.table(file.path(pathdata, "train", "y_train.txt"), header = FALSE)
subject_train <- read.table(file.path(pathdata, "train", "subject_train.txt"), header = FALSE)
#Reading the testing tables
xtest <- read.table(file.path(pathdata, "test", "X_test.txt"), header = FALSE)
ytest <- read.table(file.path(pathdata, "test", "y_test.txt"), header = FALSE)
subject_test <- read.table(file.path(pathdata, "test", "subject_test.txt"), header = FALSE)
#Read the features data
features <- read.table(file.path(pathdata, "features.txt"), header = FALSE)
#Read activity labels data
activityLabels <- read.table(file.path(pathdata, "activity_labels.txt"), header = FALSE)


#Labeling the datasets

colnames(xtrain) <- features[, 2]
colnames(ytrain) <- "activity_id"
colnames(subject_train) <- "subject_id"

colnames(xtest) = features[, 2]
colnames(ytest) = "activity_id"
colnames(subject_test) = "subject_id"

colnames(activityLabels) <- c('activity_id','activity_type')


#Merging the train and test datasets
train_dataset <- cbind(xtrain, ytrain, subject_train)
test_dataset <- cbind(xtest, ytest, subject_test)

dataset <- rbind(train_dataset, test_dataset)

names <- colnames(dataset)
mean_std_col_index <- c(grep("mean..", names), grep("std..", names))
mean_std_col_names <- c(names[mean_std_col_index], "subject_id", "activity_id")
dataset <- dataset[, mean_std_col_names]

#Labeling the activity_id
dataset <- merge(dataset, activityLabels, by = "activity_id" , all.x = TRUE)

#Removing the parenthesis
colnames(dataset) <- gsub("[()]", "", colnames(dataset))

#Transforming activity and subject to factors - 30 subject_id * 6 activity_id = 180 rows.
mean_dataset <- aggregate(. ~subject_id + activity_id, dataset, mean)
mean_dataset <- mean_dataset[order(mean_dataset$subject_id, mean_dataset$activity_id),]

#Saving the dataset to a file
write.table(mean_dataset, "cleaned_mean_dataset.txt", row.name=FALSE)


