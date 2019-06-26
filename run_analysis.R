#0.Required package dplyr
library(dplyr)

#1. Download Dataset
file_xml<-"file_final_getting_cleaning.zip"

if(!file.exists(file_xml)){
  fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl,file_xml, method = "curl")
}

if(!file.exists("UCI HAR Dataset")){
  unzip(file_xml)
}

#2. Assign to data frames and check data
features_data<-read.table("UCI HAR Dataset/features.txt",col.names = c("n","functions"))
features_data #check data
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("code","activity"))
activity_labels
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_test
x_test<-read.table("UCI HAR Dataset/test/X_test.txt",col.names = features_data$functions)
x_test
y_test<-read.table("UCI HAR Dataset/test/y_test.txt",col.names = "code")
y_test
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt",col.names = "subject")
x_train<-read.table("UCI HAR Dataset/train/x_train.txt", col.names = features_data$functions)
x_train
y_train<-read.table("UCI HAR Dataset/train/y_train.txt",col.names = "code")
y_train

#3. Binding Train Set and Test Set
x_bind<-rbind(x_train,x_test)
y_bind<-rbind(y_train,y_test)
subject_bind<-rbind(subject_train,subject_test)
merged_data<-cbind(subject_bind,y_bind, x_bind)

tidydataset<- merged_data %>% select(subject, code, contains("mean"), contains("std"))
tidydataset

tidydataset$code<-activity_labels[tidydataset$code, 2]
tidydataset$code


#4.Change labels dataset with descriptive variable names
names(tidydataset)[2]="activity"
names(tidydataset)<-gsub("Acc", "Accelerometer", names(tidydataset))
names(tidydataset)<-gsub("Gyro", "Gyroscope", names(tidydataset))
names(tidydataset)<-gsub("BodyBody", "Body", names(tidydataset))
names(tidydataset)<-gsub("Mag", "Magnitude", names(tidydataset))
names(tidydataset)<-gsub("^t", "Time", names(tidydataset))
names(tidydataset)<-gsub("tBody", "TimeBody", names(tidydataset))
names(tidydataset)<-gsub("angle", "Angle", names(tidydataset))
names(tidydataset)<-gsub("gravity", "Gravity", names(tidydataset))
names(tidydataset)<-gsub("-mean()", "Mean", names(tidydataset), ignore.case = TRUE)
names(tidydataset)<-gsub("-std()", "STD", names(tidydataset), ignore.case = TRUE)
names(tidydataset)<-gsub("-freq()", "Frequency", names(tidydataset), ignore.case = TRUE)
names(tidydataset)<-gsub("^f", "Frequency", names(tidydataset))

#5.Final data
Final_TidyData<- tidydataset %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(Final_TidyData, "FinalTidyData.txt", row.names = FALSE)

#6. Check variable data
str(Final_TidyData)
Final_TidyData