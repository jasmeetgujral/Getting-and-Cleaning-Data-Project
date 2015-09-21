# downloading data from source and saving it on local drive
d_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
local_url <- "./coursera/DataSet.zip"
download.file(d_url,local_url)

#loading data in R
unzip_url <- "./coursera/DataSet/UCI HAR Dataset"
dataActivityTest  <- read.table(file.path(unzip_url, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(unzip_url, "train", "Y_train.txt"),header = FALSE)

dataSubjectTrain <- read.table(file.path(unzip_url, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(unzip_url, "test" , "subject_test.txt"),header = FALSE)

dataFeaturesTest  <- read.table(file.path(unzip_url, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(unzip_url, "train", "X_train.txt"),header = FALSE)

#combine test and Train data
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)


# Assigning names and Combining all the data sets into one
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
 
dataFeaturesNames <- read.table(file.path(unzip_url, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

# Subselection of required data mean and std
subSelectionColumns <- names(Data)[grep("-mean|-std", names(Data))]
subData <- Data[,c(subSelectionColumns,"subject","activity")]


# Updating decriptive names for activities
dataActivityLabels <- read.table(file.path(unzip_url, "activity_labels.txt"))
subData$activity <- factor(subData$activity, levels = dataActivityLabels$V1, labels = dataActivityLabels$V2)

#Updating subjects as factors.
subData$subject <- as.factor(subData$subject)

#Preparing tidy data
tidyData = aggregate(subData[,subSelectionColumns], by=list(activity = subData$activity, subject=subData$subject), mean)

#Saving tidy Data as .txt file.
write.table(tidyData, file.path(unzip_url, "tidyData.txt"),row.names=TRUE,sep='\t')



