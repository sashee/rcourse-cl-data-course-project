library(dplyr)
library(reshape2)

# Reads the data from the training and the test sets
read_data<-function(){
  names<-read.table("UCI HAR Dataset/features.txt",sep="",header=F)
  
  read_test_data<-function(){
    test_data <- read.table("UCI HAR Dataset/test/X_test.txt", sep = "" , header = F , na.strings ="", stringsAsFactors= F)
    colnames(test_data)<-make.names(names$V2, unique=TRUE, allow_ = TRUE)
    test_labels<-read.table("UCI HAR Dataset/test/y_test.txt", sep = "" , header = F , na.strings ="", stringsAsFactors= F)
    colnames(test_labels)<-"Activity"
    test_subjects<-read.table("UCI HAR Dataset/test/subject_test.txt", sep = "" , header = F , na.strings ="", stringsAsFactors= F)
    colnames(test_subjects)<-"Subject"
    cbind(test_data,test_labels,test_subjects)
  }
  
  read_train_data<-function(){
    train_data <- read.table("UCI HAR Dataset/train/X_train.txt", sep = "" , header = F , na.strings ="", stringsAsFactors= F)
    colnames(train_data)<-make.names(names$V2, unique=TRUE, allow_ = TRUE)
    train_labels<-read.table("UCI HAR Dataset/train/y_train.txt", sep = "" , header = F , na.strings ="", stringsAsFactors= F)
    colnames(train_labels)<-"Activity"
    train_subjects<-read.table("UCI HAR Dataset/train/subject_train.txt", sep = "" , header = F , na.strings ="", stringsAsFactors= F)
    colnames(train_subjects)<-"Subject"
    cbind(train_data,train_labels,train_subjects)
  }
  
  data<-rbind(read_test_data(),read_train_data())
  
  data$Activity<-as.factor(data$Activity)
  data$Subject<-as.factor(data$Subject)
  
  data
}

# Selects only the mean and the std columns
select_data<-function(data){
  select(data, contains("mean.."),contains("std.."),Activity,Subject)
}

# Renames the activity codes with their textual representations
rename_activity<-function(data){
  activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt",sep="",header=F)
  data$Activity<-mapvalues(data$Activity, from = as.character(activity_labels$V1), to = as.character(activity_labels$V2))
  data
}

# Makes a tidy data set with the average of each variable for each activity and each subject.
tidy_data<-function(data){
  melted<-melt(data,id=c("Activity","Subject"))
  dcast(melted,Activity+Subject~variable,mean)
}

data<-read_data()
selected_data<-select_data(data)

renamed_data<-rename_activity(selected_data)

tidy_data<-tidy_data(renamed_data)

write.table(tidy_data,"tidy.txt",row.name=FALSE)
