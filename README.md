# run_analysis.R script

## Reading the data

The script first reads the data. It reads the X_ files, and adds the names from the features.txt. Then, it reads the y_ labels as an Activity column. Then, it reads the subject_ files as the Subjects column.

It then concatenates all 3 sets horizontally, then the test and training data vertically.

Finally it converts the Activity and the Subject data to factors (they were itnegeres initially)

## Selecting only the mean and the std

It selects all the columns that has mean or std in their names, along with the Activity and the Subject columns. It drops the other columns.

## Renaming activity codes to their textual representations

The script first reads the activity_labels.txt for the names, then remaps the codes to the names in the data set.

## Tidy data

The script first melts the data by Activity and Subject, then it calculates the mean of the other variables

# Structure of the script

The above steps are all refactored into different functions. The script then calls them sequentially, and finally it writes the resulting data set into the tidy.txt file
