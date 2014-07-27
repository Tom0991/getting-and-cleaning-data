# CodeBook.md

#Description of the run_analytics.R 

* downloads required data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* unzips the file if it has not been uncompressed
* creates results folder if it does not exist (all files are stored in this folder)
* loads features.txt used for columns
* loads X_train.txt, y_train.txt, subject_train.txt
* X_train contains the data using the feature data set as columns
* y_train contains the activity labels
* subject_train contains the ids
* loads and appends test dataset using X_test.txt, y_test.txt, subject_test.txt
* X_test contains the data using the feature data set as columns
* y_test contains the activity labels
* subject_test contains the ids
* appends train and test data
* rearrange the data using id
* loads activity_labels.txt
* changes the data activity row to use the activity labels
* saves the mean and std into mean_and_std.csv
* saves the tidy dataset into tidy_dataset.csv

# mean_and_std.csv

* contains 10300 (including header) rows and 82 columns (including enumeration column) in a default csv format

# tidy_dataset.csv.csv
contains 181 rows (including header) and 82 columns (including enumeration column) in a default csv format