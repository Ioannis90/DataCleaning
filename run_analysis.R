########################     read  data  ########################
testlabels <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names="label")
testsubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names="subject")
testdata <- read.table("./UCI HAR Dataset/test/X_test.txt")
trainlabels <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names="label")
trainsubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names="subject")
traindata <- read.table("./UCI HAR Dataset/train/X_train.txt")

data <- rbind(cbind(testsubjects, testlabels, testdata),
              cbind(trainsubjects, trainlabels, traindata))


###################### read features  ##################################
features <- read.table("./UCI HAR Dataset/features.txt", strip.white=TRUE, stringsAsFactors=FALSE)

featuresfinal <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]


datafinal <- data[, c(1, 2, featuresfinal$V1+2)]

####################### read labels ##############################
labels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)

datafinal$label <- labels[datafinal$label, 2]

###Appropriately labels the data set with descriptive variable names.

colnamesfinal <- c("subject", "label", featuresfinal$V2)
colnamesfinal <- tolower(gsub("[^[:alpha:]]", "", colnamesfinal))
colnames(datafinal) <- colnamesfinal

## From the data set in step 4, creates a second, independent tidy data 
##set with the average of each variable for each activity and each subject.
aggrdata <- aggregate(datafinal[, 3:ncol(datafinal)],
                       by=list(subject = datafinal$subject, 
                               label = datafinal$label),
                       mean)

write.table(format(aggrdata, scientific=T), "tidydata.txt",
            row.names=F, col.names=F, quote=2)