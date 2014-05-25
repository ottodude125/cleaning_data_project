RunAnalysis <- function() {
  
  ##### 1) MERGE TRAINING AND TEST SETS TO CREATE ONE DATA SET #####
  
  # Open files
  print("Open Files... ")
  print("Opening subject_test.txt")
  stest = read.table("UCI_HAR_Dataset/test/subject_test.txt", header=FALSE)
  print("Opening X_test.txt")
  xtest = read.table("UCI_HAR_Dataset/test/X_test.txt", header=FALSE)
  print("Opening y_text.txt")
  ytest = read.table("UCI_HAR_Dataset/test/y_test.txt", header=FALSE)
  print("Opening subject_train.txt")
  strain = read.table("UCI_HAR_Dataset/train/subject_train.txt", header=FALSE)
  print("Opening X_train.txt")
  xtrain = read.table("UCI_HAR_Dataset/train/X_train.txt", header=FALSE)
  print("Opening y_train.txt")
  ytrain = read.table("UCI_HAR_Dataset/train/y_train.txt", header=FALSE)
  
  
  # Combine all three test data sets into a single data frame
  print("Combine all three test data sets into a single data frame")
  testdf = data.frame(xtest, ytest, stest)
  
  # Combine all three train data sets into a single data frame
  print("Combine all three train data sets into a single data frame")
  traindf = data.frame(xtrain, ytrain, strain)
  
  # Merge the combined training and the test data sets to create a joined data set
  print("Merge the combined training and the test data sets to create a joined data set")
  alldf = rbind(testdf, traindf)
  
  # Open features file to get column names
  print("Open features file to get column names")
  features = read.table("UCI_HAR_Dataset/features.txt", header=FALSE)
  
  # Rename column headers to names provided in features.txt
  print("Rename column headers to names provided in features.txt")
  colnames(alldf) = features[,2]
  
  # Rename last two columns to activity and subject
  print("Rename last two columns to activity and subject")
  ncolumns = ncol(alldf)
  colnames(alldf)[c((ncolumns-1):ncolumns)] = c("activity","subject")
  
  ###### 2) Extract only the measurements on the mean and standard deviation for each measurement #####
  
  # Column name pattern that we are looking for to get only mean and standard deviation
  meanstd = grep(pattern = "std|mean", x = names(alldf))
  ncolumns = ncol(alldf)
  # add subject and activity columns to vector
  meanstd = append(meanstd,c((ncolumns-1):ncolumns))
  
  # Create df with only columns of interest
  print("Create df with only mean, std, subject, and activity columns")
  meanstddf = alldf[,meanstd]
  
  
  ##### 3) Use descriptive activity names to name the activities in the data set #####
  
  # Open activity_labels to get names of activities
  activities = read.table("UCI_HAR_Dataset/activity_labels.txt", header=FALSE, stringsAsFactors=FALSE)
  
  # Appropriately label the data set activity with descriptive activity names
  print("Change numbers in activity column to their respective activity name")
  ncolumns = ncol(meanstddf)
  for (i in activities[,1]) {
    meanstddf[meanstddf$activity==i, (ncolumns - 1)] = activities[i,2]
  }
  
  # rename all the columns with simpler names
  colnames(meanstddf) = gsub("[^[:alnum:]]", "", colnames(meanstddf))
  colnames(meanstddf) = gsub("mean", "Mean", colnames(meanstddf))
  colnames(meanstddf) = gsub("std", "Std", colnames(meanstddf))
  
  # Create a second, independent tidy data set 
  # with the average of each variable for each 
  # activity and each subject
  
  print("Building tidy data set with avg of each var for each activity of each subject...")
  # data frame to hold new tidy data set
  col_averages = as.data.frame(matrix(, nrow=0,ncol=81))
  # get list of unique subjects to process
  subjects = sort(unique(meanstddf$subject))
  # Get number of columns currently
  ncolumns = ncol(meanstddf)
  cur_row = 0 # var to keep track or row just added to df
  # loop through each subject
  for(s in subjects) {
    # Grab the activities that this subject performs
    acts = unique(meanstddf[meanstddf$subject==s, ]$activity)
    # Loop through this list of activities
    for(a in acts) {
      cur_row = cur_row + 1
      # Grab rows for this user and activity
      subact = meanstddf[ (meanstddf$subject == 1) & (meanstddf$activity == a), ]
      rownames(subact) = NULL
      # Calculate mean of each column
      means = unname(colMeans(subact[,c(1:(ncolumns-2))]))
      means = append(means, c(1,1))
      # Add this mean calculation as a new row in the col_averages df
      col_averages = rbind(col_averages, means)
      col_averages[cur_row,80] = a
      col_averages[cur_row,81] = s
    }
  }
  # Rename columns to something meaningful
  print("Renaming Column Headers")
  colnames(col_averages) = colnames(meanstddf)
  
  # Write this tidy data set to a file
  print("Saving to file")
  write.table(col_averages, file="subject_activity_variable_means.txt",row.names=FALSE)
}