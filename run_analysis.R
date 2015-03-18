#####################################
##
## You should create one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation 
##    for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
##
#####################################


#####################################
# features table : keep only mean and std var
#####################################
features <- read.table("./UCI HAR Dataset/features.txt") # 561 vectors
mean_idx <- grep("mean", features[,2])
mean_features <- features[mean_idx,]
std_idx <- grep("std", features[,2])
std_features <- features[std_idx,]

mean_std_features <- rbind(mean_features, std_features)
# order the raw to keek the same order
mean_std_features[, 1] <- as.numeric(mean_std_features[, 1])
mean_std_features <- mean_std_features[order(mean_std_features[1]),]
col_to_keep <- mean_std_features[,2]
col_to_keep <- as.character(col_to_keep)

# remove unsuse var
rm(mean_idx)
rm(std_idx)
rm(mean_features)
rm(std_features)
rm(mean_std_features)


#####################################
# reading label of the activity
#####################################
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
library(plyr)


#####################################
# reading and merging the test data
#####################################

# create a table with 2947 rows and 1 col
test <- data.frame(matrix(ncol = 1, nrow = 2947))
names(test) <- "type"
test[,]=0   # 0 test 1 train

# read test tables
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt") # 2947 set (number of the subjet)
names(subject_test) <- "subject"

y_test <- read.table("./UCI HAR Dataset/test/y_test.txt") # 2947 set of activity
y_test <- join(y_test, activity, type="inner")

print("reading X_test table ...")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt") # 2947 set of 561 vectors
names(X_test) <- features[,2]
# keep only mean and std col
X_test <- X_test[,col_to_keep]

# add in all_test the col of test, subject_test, y_test and X_test
all_test <- cbind(subject_test, test, y_test[,2], X_test)
names(all_test)[3] <- "activity"

# remove unused table
rm(subject_test)
rm(test)
rm(y_test)
rm(X_test)


#####################################
# reading and merging the train data
#####################################

# create a table with 2947 rows and 1 col
train <- data.frame(matrix(ncol = 1, nrow = 7352))
names(train) <- "type"
train[,]=1   # 0 test 1 train

# read train tables
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") # 7352 set (number of the subjet)
names(subject_train) <- "subject"

y_train <- read.table("./UCI HAR Dataset/train/y_train.txt") # 7352 set of activity
y_train <- join(y_train, activity, type="inner")
   
print("reading X_train table ...")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt") # 7352 set of 561 vectors
names(X_train) <- features[,2]
# keep only mean and std col
X_train <- X_train[,col_to_keep]

# add in all_train the col of train, subject_train, y_train and X_train
all_train <- cbind(subject_train, train, y_train[,2], X_train)
names(all_train)[3] <- "activity"

# remove unused table
rm(subject_train)
rm(train)
rm(y_train)
rm(X_train)


#####################################
# adding all_test and all_train in all_data
#####################################
all_data <- rbind(all_test, all_train)
# remove unused table
rm(all_test)
rm(all_train)
rm(features)
rm(col_to_keep)
rm(activity)


#####################################
# write data into file : merged_data
#####################################
write.table(all_data, file="./UCI HAR Dataset/merged_data.txt", row.name=FALSE)



#####################################

## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.

#####################################

library(dplyr)
data <- tbl_df(all_data)
grouped <- group_by(data, subject, activity)
for (i in 4:82) {
   col_name <- names(grouped)[i]
   names(grouped)[i] <- "value"
   resul <- summarize(grouped, mean(value))
   names(grouped)[i] <- col_name
   if (i == 4) {
      data_mean = resul
      names(data_mean)[i-1] <- col_name
   }
   else {
      data_mean <- cbind(data_mean, resul[,3])
      names(data_mean)[i-1] <- col_name
   }
}
#####################################
# write data into file : merged_data
#####################################
write.table(data_mean, file="./UCI HAR Dataset/merged_data_mean.txt", row.name=FALSE)

# remove unused table
rm(data)
rm(grouped)
rm(resul)
rm(col_name)
rm(i)
