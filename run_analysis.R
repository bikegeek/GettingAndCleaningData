run_analysis <- function(){

#----------------------DESCRIPTION------------------------------------------
#
#Read in the subject id's, the corresponding activities, and the corresponding
#measurements and store as data frames.
#Assign the column names: "subjectId" for the subject/person (value 1-30),
#"activityNumber" (value 1-6 for WALKING, WALKING_UPSTAIRS,...,LAYING),
#and the variable names in features.txt for the measurement columns.
#Then select only the measurements that
#look like <measurement name>-mean()-<other stuff> or
#<measurement name>-std()-<other stuff> to reduce the number
#of columns.  Do this for all the test data, then repeat for the training data.
#Combine the test and training data.
#------------------------------------------------------------------------------
library(reshape2)

#
# Read in the test data and any associated files, save as dataframe and
# assign column name either manually or linking with the features.txt file.
#
test_subject_table <- read.table("./test/subject_test.txt")
subject_df <- as.data.frame.matrix(test_subject_table)
names(subject_df)<-c("subject")
activity_table <- read.table("./test/y_test.txt")
activity_df <- as.data.frame.matrix(activity_table)
names(activity_df)<- c("activity")
test_measure_table <- read.table("./test/X_test.txt")
test_measure_df <- as.data.frame.matrix(test_measure_table)
test_vars <- read.csv("./features.txt", sep=" ", header=FALSE)
names(test_measure_df) <- test_vars[,2]

#Repeat for the train data
train_subject_table <- read.table("./train/subject_train.txt")
tr_subject_df <- as.data.frame.matrix(train_subject_table)
names(tr_subject_df)<-c("subject")
tr_activity_table <- read.table("./train/y_train.txt")
tr_activity_df <- as.data.frame.matrix(tr_activity_table)
names(tr_activity_df) <- c("activity")
train_measure_table <- read.table("./train/X_train.txt")
train_measure_df <- as.data.frame.matrix(train_measure_table)
names(train_measure_df) <- test_vars[,2]
train_vars <- test_vars


#Retrieve only the measurements with mean() or std()
index <- grep("mean[(]+[)]+|std[(]+[)]+", test_vars[,2])
#index <- grep("fBodyAccJerk-std[(]+|fBodyAccJerk-mean[(]+",test_vars[,2])
test <- cbind(subject_df,activity_df,test_measure_df[,index])
train <- cbind(tr_subject_df, tr_activity_df, train_measure_df[,index])

#Combine the columns to create the test data frame
#test <- cbind(subject_df,activity_df,test_measure_df)
test_merged <- as.data.frame(test)
train_merged <- as.data.frame(train)
total <- rbind(test_merged, train_merged)


#Clean up the column names corresponding to the mean and std measurements so
#they are:
# 1) Lower case
# 2) Descriptive
# 3) Are not duplicates
# 4) Have no underscores or whitespaces
#there are 32 types of measurements of format:
# tBodyAcc-XYZ, tGravityAcc-XYZ, etc.
#Replace Acc with acceleration, Gyro with gyroscope, Mag with magnitude, etc.
#colnames <- tolower(test_vars[,index])
clean<- tolower(names(total))
clean<-gsub("\\(","",clean)
clean<-gsub("\\)","",clean)
clean<-gsub("acc","acceleration",clean)
clean<-gsub("mag","magnitude",clean)
clean<-gsub("gyro","gyroscopic",clean)
clean<-gsub("std","standarddeviation",clean)
names(total)<-c(clean)
measurements<-c(clean[3:length(clean)])

#Get the average for each measurement for every subject and activity.
#i.e. for any given subject, provide the average value for every measurement
#for all activities the subject was doing.
#Do this by using melt to make each row a unique subject-activity
#(i.e. id-variable) combination.
melteddata<-  melt(total,id=c("subject","activity"))

#apply cast to the melted data to calculate the average (mean) for each
#mean and std measurement.
#usage: cast(dataframe, formula, function)
#Melt the resulting data frame to make it tidy.
md <- dcast(melteddata, subject + activity ~ variable, mean)
tidy<- melt(md,id=c("subject","activity"))

#Rename each measurement by pre-pending each name with "average"
#and give meaningful descriptors to the activity (instead of numerical value)
tidy$variable <- paste0("average-",tidy$variable)
tidy$activity <- gsub("1","walking",tidy$activity)
tidy$activity <- gsub("2","walking upstairs", tidy$activity)
tidy$activity <- gsub("3", "walking downstairs", tidy$activity)
tidy$activity <- gsub("4", "sitting", tidy$activity)
tidy$activity <- gsub("5", "standing", tidy$activity)
tidy$activity <- gsub("6", "laying", tidy$activity)

#Create a text file of the tidy data created above
workingdir <- getwd()
write.table(tidy,"tidy.txt",row.name=FALSE)
}
