features <- read.table("./features.txt")

## read test data
x_test <- read.table("./test/X_test.txt")
test_labels <- read.table("./test/Y_test.txt") ## read labeles

sub_test <- read.table("./test/subject_test.txt") ## read subject
test_subs <- unique(sub_test) ## find the levels (subjects took the test)


test <- cbind(x_test,sub_test,test_labels) ## Combine to one data frame
names(test)<- c(as.character(features[,2]),"subjects","activitylabels") ## name the data ## step4
rm(x_test, test_labels, sub_test) ## remove the data to free space

## read train data
x_train <- read.table("./train/X_train.txt")
train_labels <- read.table("./train/Y_train.txt") ## Combine to one data frame
sub_train <- read.table("./train/subject_train.txt") ## read subjects
tran_subs <- unique(sub_train) ## find the levels (subjects took the train)


train <- cbind(x_train,sub_train,train_labels) ## combine to a new data
names(train)<- c(as.character(features[,2]),"subjects","activitylabels") ## name the data ## step4
rm(x_train, train_labels, sub_train) ## remove the data to free space

## to complete step1, since every subject has different features measured values the onle common variable is 
## activity lables. However, i think it is cleaner to use rbind instead of using merge to prevent producing
## too many variables
total <- rbind(test, train)

## to complete step2
total2 <- total[,c(grep("[Mm][Ee][Aa][Nn]|[Ss][Tt][Dd]", features[,2]), length(names(total))-1,length(names(total)))]

## read activity labels
activity <- read.table("./activity_labels.txt")

## to complete step3, assign name to activity label colomn
total2$activitylabels <- sapply(total2$activitylabels, function(x) replace(x, 1, as.character(activity[x,2])))

## step4 has completed in the reading process part

## step5  package "dplry" is used to apply colMeans function to 2 groups
library(dplyr)
ncol <- length(names(total2))-2
total3 <- ddply(total2[,1:ncol], .(total2$activitylabels,total2$subjects), colMeans)

names(total3)[1:2] <- c("activity", "subjects") ## give names back

write.table(total3, file = "mean of mean and std related obs (independent tidy data set).txt",row.name=FALSE)

## test reading of the output file
temp <- read.table("./mean of mean and std related obs (independent tidy data set).txt")
