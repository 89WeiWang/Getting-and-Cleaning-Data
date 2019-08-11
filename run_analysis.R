#Download and unzip file
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "GETDATA.zip")
GETDATA <- unzip("GETDATA.zip")

#Read TEST file
test_X <- read.table("C:/Users/weiwi/Downloads/Compressed/coursea/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
test_y <- read.table("C:/Users/weiwi/Downloads/Compressed/coursea/UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")
test_subject <- read.table("C:/Users/weiwi/Downloads/Compressed/coursea/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")

#Read TRAIN file
train_X <- read.table("C:/Users/weiwi/Downloads/Compressed/coursea/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
train_y <- read.table("C:/Users/weiwi/Downloads/Compressed/coursea/UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")
train_subject <- read.table("C:/Users/weiwi/Downloads/Compressed/coursea/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")

features <- read.table("C:/Users/weiwi/Downloads/Compressed/coursea/UCI HAR Dataset/features.txt", quote="\"", comment.char="", stringsAsFactors = F)
activity_labels <- read.table("C:/Users/weiwi/Downloads/Compressed/coursea/UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="", stringsAsFactors = F)


#Extract mean and std
library(dplyr)
library(stringr)
library(reshape2)
index1 <- str_which(features[[2]], "mean")
index2 <- str_which(features[[2]], "std")
index <- c(index1, index2)

#bind together
train <- cbind(train_subject, train_y, train_X[index])
test <- cbind(test_subject, test_y, test_X[index])

#merge data
all <- rbind(train, test)
colnames(all) <- c("subject", "activity", features[[2]][index])
all$activity <- as.factor(all$activity, levels = activity_labels[,1], labels = activity_labels[,2])
all$subject <- as.factor(all$subject)

#Creat new data
newdata <- all %>% melt(id = c("subject", "activity")) %>% dcast(subject + activity ~ variable, mean)