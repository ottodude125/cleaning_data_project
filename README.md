
## Description
The run_analysis.R script analyzes the data from the "Human Activity Recognition Using Smartphones Data Set" and builds a new tidy data set which is saved to the file subject_activity_variable_means.txt for further analysis. 

The features for the experimental database came from experiments carried out with 30 subjects performing certain activities. The subjects were wearing a smartphone on their waist while performing these activites and data from the accelerometer and gyroscope were collected.

## Original Dataset
The original dataset was obtained from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]. Below is a list and description of each file. 

* activity_labels.txt - List of activity names that were performed
* features.txt - List of all features recorded/calculated
* features_info.txt - Info describing how features were obtained and what they mean
* test/X_test.txt - Test set
* test/y_test.txt - Test labels
* test/subject_test.txt - Subjects part of testing data
* train/X_train.txt - Training set
* train/y_train.txt - Training labels
* train/subject_train.txt - Subjects part of training data

Additional information about the test and original data files can be found at [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones].

## Description of Script Analysis
The run_analysis.R script reads multiple text files, analyzes them, and builds a new tidy data set which is saved to file for future analysis. The original data and files are provided so that rerunning the script is simple. 

1. Reads in all three test data sets and combines them into a single data frame
2. Reads in all three train data sets and combines them into a single data frame
3. Merges test and train data frames together
4. Rename column headers to names provided in features.txt
5. Only interested in mean or std columns so drop all others from df
6. Update activity column to use descriptive names instead of integer
7. update all columns to use clean names instead of original names(remove extra characters)
  * ex. tBodyAcc-mean()-X is converted to tBodyAccMeanX
8. Lastly the df is analyzed and a new tidy data set is created. 

## Results
The resulting data set contains a single row for each activity an individual performed. The values for each feature column are the calculated mean of that subjects specific activity.















