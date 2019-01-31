# How is Healthcare related to political Orientation in the U.S.?
## Requirements
The following R Packages are required to run the project
### Preprocessing and data management
- deplyr
### Classification
- e1071 (SVM)
- randomForest
### Visualization
- ggplot2
## Data
Data is available here: https://www.kaggle.com/hhs/health-insurance-marketplace

Rates.csv and Benefits.csv must be manually split into 2015 and 2016 data and put in `./data`

## Run
```
$ RScript exploration.R
```
```
$ Rscript classification.R
```
