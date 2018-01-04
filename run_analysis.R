library("data.table")
library("reshape2")
library("dplyr")
# started at Jan 4th 2018 @ 1900 -> 2200

#set file names, change if you want
## Start Downloading needed files
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
## End Downloading needed files
# use the working data directory to load all the data, then come back to the regular work dir
## Start Variable Loads
setwd(dirUCI)
featuresTable <- data.table::fread("features.txt", col.names=c("featureNumber","featureNameAndMathematicalMethod"))
featureNames <- featuresTable$featureNameAndMathematicalMethod #extract this to label your data
subjectTrainTable <- data.table::fread(file.path("train", "subject_train.txt"))
subjectTestTable  <- data.table::fread(file.path("test" , "subject_test.txt" ))
XTrainTable <- data.table::fread(file.path("train", "X_train.txt"), col.names=featureNames) #clever labeling
XTestTable  <- data.table::fread(file.path("test" , "X_test.txt" ), col.names=featureNames) #clever labeling
YTrainTable <- data.table::fread(file.path("train", "y_train.txt"))
YTestTable  <- data.table::fread(file.path("test" , "y_test.txt" ))
activityNamesTable <- data.table::fread("activity_labels.txt", col.names=c("activityNumber","activityName"))
setwd("../../")
## Complete Variable Loads

## Start Manipulation
subjectMergedTable <- rbind(subjectTrainTable, subjectTestTable)
XMergedTable <- rbind(XTrainTable, XTestTable)
YMergedTable <- rbind(YTrainTable, YTestTable)
subjectMergedTable <- rename(subjectMergedTable, subject=V1)
YMergedTable <- rename(YMergedTable, activityNumber=V1)
metaData <- cbind(subjectMergedTable, YMergedTable)
colLabelledData <- cbind(metaData, XMergedTable)
colLabelledData <- colLabelledData[ ,grepl("subject|activityNumber|mean\\(|std\\(", names( colLabelledData )), with=FALSE] # grepl is awesome, use to remove unwanted colums with subsetting data tables
labelledData <- merge(colLabelledData, activityNamesTable, by="activityNumber", all.x=TRUE)
labelledData$subject <- as.factor(labelledData$subject)
labelledData$activityName <- as.factor(labelledData$activityName)
means <- labelledData %>% group_by(activityName, subject) %>% summarize_each(funs(mean))
## Start Manipulation
## Write Results
write.table(means, file = "tidydata.txt", row.names = FALSE, col.names = TRUE)
## End Write Results