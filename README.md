## Description of the files

The following files are in the current directory :
* run_analysis.R     : the code source
* README.md          : this doc
* CodeBook.md        : description of the data

Then, the directory "UCI HAR Dataset" contain :
* test dir              : dir with the test data
* train dir             : dir with the train data
* activity_labels.txt   : name of the 6 activity labels
* features.txt          : name of the 561 vectors
* features_info.txt     : description of the vectors
* merged_data.txt       : tidy data produced on step 4 with the script run_analysis.R
* merged_data_mean.txt  : tidy data produced on step 5 with the script run_analysis.R
* README.txt            : original description of the files

The directory "UCI HAR Dataset/test" contain :
* subject_test.txt   : the id of the subject
* X_test.txt         : the data of the 561 vectors
* y_test.txt         : the id of the activity

The directory "UCI HAR Dataset/train" contain :
* subject_train.txt   : the id of the subject
* X_train.txt         : the data of the 561 vectors
* y_train.txt         : the id of the activity


## Description of what the script does to produce the first tidy data

The script run_analysis.R does the following :

1. read features.txt in a table and with the grep command only extract the mean and the std col.
2. read activity_labels.txt in a table
<br><br>
(test table)
3. create a table with 2947 rows and 1 col for the test data. This table contain a col to identify the type of the data (0 for test data and 1 for train data)
4. read subject_test.txt in a table
5. read y_test.txt in a table and join it with activity table to obtain the name the activity instead the id
6. read X_test.txt in a table and keep only the col mean and std (obtained in step 1)
7. combine the table (cbind) subject_test, test, y_test and X_test in one table (all_test)
<br><br>
(train table)
8. id step 3 with 7352 row
9. id step 4 with subject_train.txt
10. id step 5 with y_train.txt
11. id step 6 with X_train.txt
12. id step 7 with subject_train, y_train, X_train in table all_train
<br><br>
13. combine all_test and all_train (rbind) in one table (all_data)
14. write this table on the disc in the file : merged_data.txt


## Description of what the script does to produce the second tidy data

The script run_analysis.R does the following : 
1. group the data in all_data table by subject and by activity
2. make a loop to calculate for all the col mean and std the mean
3. create a new table (data_mean) with the resul
4. write this table on the disc in the file : merged_data_mean.txt


### Notes : during the script execution, I use the command rm() to free the memory