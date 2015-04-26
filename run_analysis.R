library(dplyr)
library(reshape2)

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

select_data<-function(data){
  select(data, contains("mean.."),contains("std.."),Activity,Subject)
}

rename_activity<-function(data){
  activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt",sep="",header=F)
  data$Activity<-mapvalues(data$Activity, from = as.character(activity_labels$V1), to = as.character(activity_labels$V2))
  data
}

data<-read_data()
selected_data<-select_data(data)

renamed_data<-rename_activity(selected_data)


melted<-melt(renamed_data,id=c("Activity","Subject"))
casted<-dcast(melted,Activity+Subject~variable,mean)

write.table(casted,"tidy.txt",row.name=FALSE)
