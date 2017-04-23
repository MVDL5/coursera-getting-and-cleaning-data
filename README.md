# Getting and Cleaning Data: Assignment

In the repository an R script, `run_analysis.R` and a `codebook` is provided.

`run_analysis.R` performs the following actions:

1. Download the dataset (as a zip file) and extract the file if it does not yet exist
2. Load the features and activity label datasets and rename the columns 
3. Complete the training dataset by combining the training data set and its related activity labels and subjects.
4. Perform the same as in (3) for the test dataset.
5. Bind the training dataset and the test dataset.
6. Convert the activity labels to factors to be more descriptive
7. Rename all variables of the dataset to the feature names.
8. Extract the mean and std of the dataset.
9. Create a second independent tidy data set, `tidy.txt` with the average of each variable for each activity and each subject

