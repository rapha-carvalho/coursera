##Final Project

The first thing to do is to download the file available on: 
`"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"`

After that, we have to unzip the file so we can access all the datasets available.

You'll notice that we have 28 files to be analyzed. 

Despite the huge number of files, we don't need to make transformations on all of them. The files that we'll work on are:

- X_train.txt -> contains the test features
- Y_train.txt -> contains the test target
- subject_train.txt


- X_test.txt -> contains the test features
- Y_test.txt  -> contains the test target
- subject_test.txt

- features.txt -> contains the name of each feature
- activity_labels.txt -> contains the labels for every activity


Now that we know the files that we'll work on, we'll need to load them into R. 

```
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
```

The files are now loaded, but you'll notice that, they're not labeled correctly. So, the next step is to label each dataset.

```
colnames(xtrain) <- features[, 2]
colnames(ytrain) <- "activity_id"
colnames(subject_train) <- "subject_id"

colnames(xtest) = features[, 2]
colnames(ytest) = "activity_id"
colnames(subject_test) = "subject_id"

colnames(activityLabels) <- c('activity_id','activity_type')

```

Our datasets are now labeled. Now it's time to combine them into a single dataset that we'll perform our transformations:

```
#Merging the train and test datasets
train_dataset <- cbind(xtrain, ytrain, subject_train)
test_dataset <- cbind(xtest, ytest, subject_test)

dataset <- rbind(train_dataset, test_dataset)

```

The next step is to select only the columns related to "mean" and "std" metrics:

```
names <- colnames(dataset)
mean_std_col_index <- c(grep("mean..", names), grep("std..", names))
mean_std_col_names <- c(names[mean_std_col_index], "subject_id", "activity_id")
dataset <- dataset[, mean_std_col_names]

```

Then, we remove the parenthesis of each column to make the labels more readable:

```
#Removing the parenthesis
colnames(dataset) <- gsub("[()]", "", colnames(dataset))

```

Our final step is to create a second dataset that computes the average of each variable for each activity and each subject. This dataset must have 180 rows, as we have 6 distinct activities and 30 subjects.

```
#Transforming activity and subject to factors - 30 subject_id * 6 activity_id = 180 rows.
mean_dataset <- aggregate(. ~subject_id + activity_id, dataset, mean)
mean_dataset <- mean_dataset[order(mean_dataset$subject_id, mean_dataset$activity_id),]

#Saving the dataset to a file
write.table(mean_dataset, "cleaned_mean_dataset.txt", row.name=FALSE)

```