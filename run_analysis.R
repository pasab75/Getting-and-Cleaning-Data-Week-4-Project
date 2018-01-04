library("data.table")
library("reshape2")
library("dplyr")
# started at Jan 4th 2018 @ 1900 -> 2200

project1 <- function(){
  fileName <- "./data/trackers.zip"
  dirUCI <- "./data/UCI HAR Dataset/"
  if(!file.exists("./data")){dir.create(("./data"))}
  if(!file.exists(fileName)){
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl,destfile = fileName)
  }
  if (!file.exists("UCI HAR Dataset")) {
    unzip(fileName, exdir='./data')
  }
  setwd(dirUCI)
  featuresTable <- data.table::fread("features.txt", col.names=c("featureNumber","featureNameAndMathematicalMethod"))
  featureNames <- featuresTable$featureNameAndMathematicalMethod
  subjectTrainTable <- data.table::fread(file.path("train", "subject_train.txt"))
  subjectTestTable  <- data.table::fread(file.path("test" , "subject_test.txt" ))
  XTrainTable <- data.table::fread(file.path("train", "X_train.txt"), col.names=featureNames)
  XTestTable  <- data.table::fread(file.path("test" , "X_test.txt" ), col.names=featureNames)
  YTrainTable <- data.table::fread(file.path("train", "y_train.txt"))
  YTestTable  <- data.table::fread(file.path("test" , "y_test.txt" ))
  activityNamesTable <- data.table::fread("activity_labels.txt", col.names=c("activityNumber","activityName"))
  setwd("../../")
  subjectMergedTable <- rbind(subjectTrainTable, subjectTestTable)
  XMergedTable <- rbind(XTrainTable, XTestTable)
  YMergedTable <- rbind(YTrainTable, YTestTable)
  #print("#################################")
  subjectMergedTable <- rename(subjectMergedTable, subject=V1)
  #print(head(subjectMergedTable, n=10))
  #print(names(subjectMergedTable))
  #print("#################################")
  #print(head(XMergedTable, n=10))
  #print(names(XMergedTable))
  #print("#################################")
  YMergedTable <- rename(YMergedTable, activityNumber=V1)
  #print(head(YMergedTable, n=10))
  #print(names(YMergedTable))
  metaData <- cbind(subjectMergedTable, YMergedTable)
  colLabelledData <- cbind(metaData, XMergedTable)
   
  colLabelledData <- colLabelledData[ ,grepl("subject|activityNumber|mean\\(|std\\(", names( colLabelledData )), with=FALSE]
  #print(head(colLabelledData, n=30))
  labelledData <- merge(colLabelledData, activityNamesTable, by="activityNumber", all.x=TRUE)
  labelledData$subject <- as.factor(labelledData$subject)
  labelledData$activityName <- as.factor(labelledData$activityName)
  print("################")
  print(head(labelledData, n=20))
  total_mean <- labelledData %>% group_by(activityName, subject) %>% summarize_each(funs(mean))
  #labelledData$melt <- melt(labelledData, id = c("subject", "activityName"))
  #labelledData$mean <- dcast(labelledData$melt, subject + activityName ~ variable, mean)
  print("################")
  print(head(total_mean, n=20))
  write.table(total_mean, file = "tidydata.txt", row.names = FALSE, col.names = TRUE)
  return(total_mean)
}