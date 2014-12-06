Getting_and_cleaning_data-project-
==================================
This file a "READ ME" file as the codebook of description of processing the raw data obtain from "Getting and Cleaning Data" course project on Cousera



## Objective
To convert raw data to tidy data set with decriptive names 

## Raw data
Raw data was downloaded throught the link provided by [Course Project](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

A full description of all the variables and observations can be found in the raw data file. Here, only limited detail is listed:

-----------------------------------------------------------------------------------------------------------------------

The experiments have been carried out with a group of **30** volunteers within an age bracket of 19-48 years. Each person performed **six** activities 

* WALKING,
* WALKING_UPSTAIRS,
* WALKING_DOWNSTAIRS, 
* SITTING, 
* STANDING, 
* LAYING

wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% (*21 subjects*) of the volunteers was selected for generating the training data (subject: **1, 3, 5, 6, 7, 8, 11, 14, 15, 16, 17, 19, 21, 22, 23, 25, 26, 27, 28, 29, 30**) and 30% (*9 subjects*) the test data (subject: **2, 4, 9, 10, 12, 13, 18, 20, 24**).A **561**-feature vector with time and frequency domain variables was collected for both groups

---------------------------------------------------------------------------------------------------------------------------

## Processed data

The raw data was read and named as the following codes

    features <- read.table("./features.txt")
    
    ## read test data
    x_test <- read.table("./test/X_test.txt")
    test_labels <- read.table("./test/Y_test.txt") ## read labeles
    sub_test <- read.table("./test/subject_test.txt") ## read subject
    test_subs <- unique(sub_test) ## find the levels (subjects took the test)
    test <- cbind(x_test,sub_test,test_labels) ## Combine to one data frame
    names(test)<- c(as.character(features[,2]),"subjects","activitylabels") ## name the data ## step4
    rm(x_test, test_labels, sub_test) ## remove the data to free space

The same code is applied to the train group of data.

### STEP1 _Merges the training and the test sets to create one data set_
It is resonable to use 
    total <- rbind(test, train)
to merge these two data set.

### STEP2 _Extracts only the measurements on the mean and standard deviation for each measurement_
Regular expression `[Mm][Ee][Aa][Nn]|[Ss][Tt][Dd]` is used to find *mean* or *standard deviation* related variables. The code detail is as below:

    total2 <- total[,c(grep("[Mm][Ee][Aa][Nn]|[Ss][Tt][Dd]", features[,2]),
        length(names(total))-1,length(names(total)))]


### STEP3 _Uses descriptive activity names to name the activities in the data set_
Firstly, read the activity labels from the text file and then assign them to *activitylabels* column in order to have descriptive names. The codes fulfilling this function is attached below:

    ## read activity labels
    activity <- read.table("./activity_labels.txt")

    ## to complete step3, assign name to activity label colomn
    total2$activitylabels <- sapply(total2$activitylabels, function(x) replace(x, 1, as.character(activity[x,2])))


### STEP4 _Appropriately labels the data set with descriptive variable names_
This step has been completed in **STEP1** 

### STEP5 _From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject_
'dplyr' library was installed to simply the applying 'colMeans()' function process. The code details is, 

    library(dplyr)
    ncol <- length(names(total2))-2
    total3 <- ddply(total2[,1:ncol], .(total2$activitylabels,total2$subjects), colMeans)

    names(total3)[1:2] <- c("activity", "subjects") ## give names back

    write.table(total3, file = "mean of mean and std related obs (independent tidy data set).txt",row.name=FALSE)

    ## test reading of the output file
    temp <- read.table("./mean of mean and std related obs (independent tidy data set).txt")

_Note that `row.name=FALSE` is set in `write.table()` function_

**Now tidy data set is generated!**