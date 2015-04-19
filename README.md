How to clean up the Samsung wearables data.

Obtain the data:
---------------
Download the zipped data for this analysis from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Copy the zip file to a directory you created for performing the analysis, this
will be referred to as the working directory. Example: /home/someuser/analysis/

unzip the file using your operating system's unzip application.

Copy the run_analysis.R file to the top of your working directory.

Running the script:
------------------
Set your working directory to the UCI HAR Dataset directory.
Depending on your operating system: /home/someuser/analysis/UCI Har Dataset

Be sure to have reshape2 package installed, as this library is used by the
script.

In RStudio, source the run_analysis.R script.

Invoke the script: run_analysis()

A tidy.txt file is created with the average of the mean and standard deviation
measurements for each subject (person) in the study for each activity in which
the subject participated.  

This file will be created in the UCI HAR Dataset directory (inside your working
directory).

Overview of script
------------------
The run_analysis script combines the test and train data collected on 30 test subjects who 
wore Samsung smart phones which tracked their activity.  The activities are broken down into
any of the following six activities: walking, walking upstairs, walking downstairs, sitting,standing, and laying.  Only the measurements for mean and standard deviation were collected and 
averaged for each activity, for each subject.  The measurements are either frequency or time-averaged and measure gryroscopic, acceleration, and jerk forces. 

The resulting file contains the subject, activity, measurement name, and average value for that measurement.
