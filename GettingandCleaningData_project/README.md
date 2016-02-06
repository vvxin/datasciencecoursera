# README.md
Getting and Cleaning data - Coursera 

### Project description 

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected. 

### Data source

One of the most exciting areas in all of data science right now is wearable computing - see for example [this article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/) . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

### Content in the repo directory

- **run_analysis.R**  R scrips to prepare and manipulate the data set (explain more below)
- **tidy_data.csv**  The final tidy data submitted (cleaned and aggregated)
- **all_mean_and_std.csv**  The data containing only the measurements on the mean and standard deviation for all train and test measurement (much bigger than tidy_data.csv)
- **README.md**  This file
- **CodeBook.md**  Document describing the variables of tidy_data.csv
- **dataset.zip**  raw data file downlaoded from Internet (too big to sync)

### How the "run_analysis.R" script works

The script follows exactly the course project instruction:

0. Prepare the working environment and the dataset
 * load dplr 
 * set worikng directory
 * download and unzip the dataset

1. Merges the training and the test sets to create one data set
 * read "features.txt" as column names later
 * read and merge X txt (561 features), then assign column names
 * read and merge Y txt (activity code), assign variable name as "activity"
 * read and merge subject txt (volunteer id), assign variable name as "volunteer_id"
 * merge id and activity together with main features data

2. Extracts only the measurements on the mean and standard deviation for each measurement. 
 * subset only the measurements on the mean and standard deviation with BaseR.  (dplyr::select(contains()) doesn't work here probably because of the invalid charactors in the column names)

3. Uses descriptive activity names to name the activities in the data set
 * arrange data by id and activity code
 * uses *for loop* to substitude activity code as activity discriptions

4. Appropriately labels the data set with descriptive variable names. 
 * descriptive variable names have done in step 2
 * generate csv file called "all_mean_and_std.csv"

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
 * uses group_by and summarise_each to aggregate the average of each variable for each activity and each subject
 * generate TXT file of the final tidy data set called "tidy_data.csv"