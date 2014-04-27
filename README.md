GettingAndCleaningData
======================

Getting and Cleaning Data coursera assignment repo

The run_analysis.R script reads in 7 different files if "UCI HAR Dataset" is set as working directory. The file with the feature names as column headers, and twice the x-features, y-outcomes and subject numbers for training and test data set.

The combined_df contains, subject, activity and 561 variables as columns. The selected _df only contains the mean() and std() columns. It is not saved in a text file later.

The activities (1-6) are replaced by activity names like (WALKING, SITTING etc.)

The tidy_data.txt contains the average of ALL variables for specific subject AND activity. Therefore 30 subjects X 6 activities = 180 rows.

loop_subjects and loop _activities are created to loop through the subjects and activities.
