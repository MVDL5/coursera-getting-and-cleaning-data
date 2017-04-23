# Collect, work with and clean a data set
# Prepare tidy data to analyse later


#You should create one R script called run_analysis.R that does the following.

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Download, unzip files
library(downloader)
library(plyr)
library(reshape2)

# Download and unzip dataset if it does not yet exists

if(!file.exists("dataset.zip")) {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download(url, dest="dataset.zip", mode="wb") 
  unzip ("dataset.zip", exdir = ".")
}

# First, load the features and activitylabels and rename columns where necessary

features <- read.table('./UCI HAR Dataset/features.txt')
colnames(features) <- c("featurenumber", "feature")

activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Load the training data and rename columns

trainingset <- read.table("./UCI HAR Dataset/train/X_train.txt")

traininglabels <- read.table("./UCI HAR Dataset/train/y_train.txt")
colnames(traininglabels) <- "activity"

trainingsubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(trainingsubject) <- "subject"

# Bind the above data into one dataset called trainingdata
trainingdata <- cbind(traininglabels, trainingsubject, trainingset)

# Load the test data and rename columns

testset <- read.table("./UCI HAR Dataset/test/X_test.txt")

testlabels <- read.table("./UCI HAR Dataset/test/y_test.txt")
colnames(testlabels) <- "activity"

testsubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
colnames(testsubject) <- "subject"

# Bind the above data into one dataset called testdata
testdata <- cbind(testlabels, testsubject, testset)

# Bind the training and test set into one dataset
bigdata <- rbind(trainingdata, testdata)

# Convert the activity labels to factors to use the description rather than the numbers
bigdata$activity <- as.factor(bigdata$activity)
bigdata$activity <- mapvalues(bigdata$activity, from = as.vector(activitylabels$V1), to = as.vector(activitylabels$V2))

# Rename all variables to the names of the features of the bigdata
colnames(bigdata) <- c("activity", "subject", as.vector(features$feature))

# Extract only the mean and std
test <- grep("mean\\(\\)|std\\(\\)", colnames(bigdata))
bigdata <- bigdata[ , c(1,2, test)]

# Creating a second independent tidy data set with the avergae of each variable for each activity and each subject

meltdata <- melt(bigdata, id = c("activity", "subject"))
meanbigdata <- dcast(meltdata, activity + subject ~ variable, mean)

write.table(meanbigdata, "tidydata.txt", row.names = FALSE, quote = FALSE)
