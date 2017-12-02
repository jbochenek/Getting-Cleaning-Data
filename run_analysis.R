install.packages("reshape2")
library(reshape2)
#Dowload required files to working directory

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])


featuresneed <- grep(".*mean.*|.*std.*", features[,2])
featuresneed.names <- features[featuresneed,2]
featuresneed.names = gsub('-mean', 'Mean', featuresneed.names)
featuresneed.names = gsub('-std', 'Std', featuresneed.names)
featuresneed.names <- gsub('[-()]', '', featuresneed.names)

train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresneed]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresneed]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresneed.names)

allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
