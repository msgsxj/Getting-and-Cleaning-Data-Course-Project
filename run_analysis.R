run_analysis <- function(notdownloaded = F){
  # set path
  setwd("C:/Users/msgsxj/Desktop/coursera/Getting and Cleaning Data")
  
  # 1.Merge the training and the test sets to create one data set.
  if (notdownloaded){
    # download projectData.zip
    if (!file.exists("data")){
      dir.create("data")
    }
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileUrl, destfile = "./data/projectData.zip")
  }
  
  # unzip projectData.zip
  unzip("./data/projectData.zip", exdir = "./data")
  
  # load data (it takes some time)
  X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt") # 7352*561
  y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt") # 7352*1
  subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt") # 7352*1
  X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt") # 2947*561
  y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt") # 2947*1
  subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt") # 2947*1
  
  # merge the training and the test sets
  trainData <- cbind(subject_train, y_train, X_train)
  testData <- cbind(subject_test, y_test, X_test)
  Data_emerged <- rbind(trainData, testData)
  
  # 2. Extract only the measurements on the mean and standard deviation for each measurement. 
  
  # load feature name
  featureName <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
  
  # Extracts only the measurements on the mean and standard deviation for each measurement.
  featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName)
  Data_extracted <- Data_emerged[c(1, 2, featureIndex + 2)]
  names(Data_extracted) <- c("subject","y",featureName[featureIndex])
  
  # 3. Uses descriptive activity names to name the activities in the data set
  
  #load activaty names
  activityNames <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
  
  # factor Data_extracted$y, name it activaty
  Data_extracted$y <- factor(Data_extracted$y, levels=1:6, labels=activityNames[,2])
  names(Data_extracted)[2] <- "activity"
  
  # 4. Appropriately labels the data set with descriptive variable names.
  
  names(Data_extracted) <- gsub("\\()", "", names(Data_extracted))
  names(Data_extracted) <- gsub("^t", "time", names(Data_extracted))
  names(Data_extracted) <- gsub("^f", "freq", names(Data_extracted))
  
  # 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  
  library(dplyr)
  groupData <- Data_extracted %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
  write.table(groupData, "./data/UCI HAR Dataset/groupData.txt", col.names = F, row.names = F)
  write.table(names(groupData), "./data/UCI HAR Dataset/groupData_feature.txt")
  print("done")
}