# Variables and Data
 - groupData.txt has the tidy data set
 - groupData_feature.txt has corresponding feature names
 - all of the features are named descriptively,like "time...-mean-X"or"time...-std-Z"or"freq...-std"
 - all data are within [-1,1]

# Procedure
1. Merges the training and the test sets to create one data set.
 - setwd()
 - download projectData.zip(download.file())
 - unzip projectData.zip(unzip())
 - read data into R(read.table())
 - emerge data(cbind(),rbind())

2. Extracts only the measurements on the mean and standard deviation for each measurement.
 - read feature name data into R(read.table())
 - find feature with mean() or std()(grep())

3. Uses descriptive activity names to name the activities in the data set
 - read activaties name data into R(read.table())
 - factor y and rename it as activaty(factor())

4. Appropriately labels the data set with descriptive variable names.
 - replace "()" with "","^t" with "time","^f" with "freq"(gsub())

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
 - group data with subject and activity(dplyr::group_by())
 - save data and feature name as txt(write.table())