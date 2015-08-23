library(plyr)
##Getting train and test data sets##

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

##Merging train and test data sets to create single data sets##

x_data <- rbind(x_train, x_test)

y_data <- rbind(y_train, y_test)

subject_data <- rbind(subject_train, subject_test)

##Extracting mean and standard deviation for every measurement##
features <- read.table("UCI HAR Dataset/features.txt")
featuresWanted <- grep(".*mean.*|.*std.*",features[, 2])

##Correcting names for the desired features##
x_data <- x_data[, featuresWanted]

names(x_data) <- features[featuresWanted, 2]

##Useing descriptive activity names to name the activities in the data set##

activities <- read.table("UCI HAR Dataset/activity_labels.txt")

y_data[, 1] <- activities[y_data[, 1], 2]

names(y_data) <- "activity"

##Appropriately labels the data set with descriptive variable names##
names(subject_data) <- "subject"

all_data <- cbind(x_data, y_data, subject_data)

##tidy data set with the average of each variable for each activity and each subject##

average_data <- ddply(all_data, c("subject", "activity"), function(x) colMeans(x[,1:66]))
write.table(average_data, "tidy_data.txt", row.name=FALSE)
