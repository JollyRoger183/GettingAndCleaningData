#You should create one R script called run_analysis.R that does the following.
#
#Merges the training and the test sets to create one data set.
#Extracts only the measurements on the mean and standard deviation for each measurement.
#Uses descriptive activity names to name the activities in the data set
#Appropriately labels the data set with descriptive activity names.
#Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
rm(list=ls())
#setwd("C:\\02_LEARNING\\coursera\\Data Science\\03 - Getting and Cleaning Data\\Assesment Project\\UCI HAR Dataset")

# set working directory so the folder contains the "train" and "test" folder

# combine the feature-X values with the outcome-Y values via cbind()
#===================================================================

# read in subjects
subject_train <- read.table(file="train/subject_train.txt", header=FALSE, sep="", stringsAsFactors=FALSE)
subject_test <- read.table(file="test/subject_test.txt", header=FALSE, sep="", stringsAsFactors=FALSE)

# read in training data
x_train <- read.table(file="train/X_train.txt", header=FALSE, sep="")
y_train <- read.table(file="train/y_train.txt", header=FALSE, sep="")
# cbind training data
train_df <- cbind(subject_train, y_train, x_train)

# read in test data
x_test <- read.table(file="test/X_test.txt", header=FALSE, sep="")
y_test <- read.table(file="test/y_test.txt", header=FALSE, sep="")
# cbind test data
test_df <- cbind(subject_test, y_test, x_test)

# create final data-frame
combined_df <- rbind(train_df, test_df)


# read in feature names
#======================
feature_names <- read.table(file="features.txt", stringsAsFactors=FALSE)
# extract feature names from second column
features <- feature_names[ , 2]

# add "activity" to the feature_names for the last column
features <- c("subject", "activity", features)

# rename variables of combined_df with feature_names
names(combined_df) <- features


# read in activity labels
#========================
activity_names <- read.table(file="activity_labels.txt", stringsAsFactors=FALSE)

# activity_names$V2
#[1] "WALKING"            "WALKING_UPSTAIRS"   "WALKING_DOWNSTAIRS" 
#[4] "SITTING"            "STANDING"           "LAYING"            

# rename activities from 1-6 with WALKING, SITTING etc.
for (i in 1:6){
    combined_df$activity[combined_df$activity == activity_names$V1[i]] <- activity_names$V2[i]
}

# Extracts only the measurements on the mean and standard deviation for each measurement
#=======================================================================================

# select columns that contain "mean()"
mean_columns <- grep(pattern="mean()", x=names(combined_df), value=FALSE, fixed=TRUE)
std_columns <- grep(pattern="std()", x=names(combined_df), value=FALSE, fixed=TRUE)

# include the first column (subject) and the second column that contains the activities
selected_columns <- sort(c(1, 2, mean_columns, std_columns))

selected_df <- combined_df[ , selected_columns]


# Creates a second, independent tidy data set with the average of each variable for each activity and each subject
#=================================================================================================================

# starting from combined_df again
activities <- activity_names[ , 2]

# average values per subject and activity
temp_matrix <- matrix(NA, nrow=180, ncol=ncol(combined_df))
avg_subject_activity <- as.data.frame(temp_matrix)               # 180 rows

names(avg_subject_activity) <- names(combined_df)

loop_subjects <- rep(1:30, each=6)
loop_activities <- rep(activities, 30)

# Fill all 180 rows, for each subject (1:30) with the averages of all variables by certain activities (1:6)
for(i in 1:180){
    avg_subject_activity[i, 1] <- loop_subjects[i]   # add subject to first column of i_th row
    avg_subject_activity[i, 3:563] <- colMeans(combined_df[combined_df$subject == loop_subjects[i] &
                                                           combined_df$activity == loop_activities[i], 3:563], na.rm=T)    # add averages
    avg_subject_activity[i, 2] <- loop_activities[i]  # add activity to second column of i_th row
}

# move activity

write.table(x=avg_subject_activity, file="tidy_data.txt", row.names=FALSE, col.names=TRUE, sep="\t")

# for uploading a smaller tidy_data.txt file to the upload server:
temp_tidy_data <- avg_subject_activity[1:30, ]
write.table(x=temp_tidy_data, file="small_tidy_data.txt", row.names=FALSE, col.names=TRUE, sep="\t")
