# Getting and Cleaning Data Project Week 4

This contains a single script that creates a txt file tidydata.txt by the following process:
* Create a ./data directory to work in
* Downloading the source zip to the data directory
* Unzipping the source file
* Loading all needed files into R memory
* Combining data through cbind and rbind
* Labelling data appropriately, factoring data
* Grouping data to produce the desired result

### Initial Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

See https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones for more information

How to run this project
-------------------------------

1. Clone the project locally
2. Run the R script data_analysis.R. it performs the steps listed above
