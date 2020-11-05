# Josephine Dufitinema
# 05/11/2020
# Exercise 2 - Data wrangling
# Data source: https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-meta.txt

#libraries
library(dplyr)


data <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", 
                   sep="\t", header=TRUE) # read full data from the web
str(data) # It's a data frame

dim(data) # 183 observations or rows
          # 60 variables or columns

# Create an analysis data set

# First, create attitude, deep, stra, and surf columns

# create column 'attitude' by scaling the column "Attitude"
data$attitude <- data$Attitude / 10

# Questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", 
                    "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05",
                       "SU13","SU21","SU29","SU08","SU16","SU24",
                       "SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04",
                         "ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(data, one_of(deep_questions))
data$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(data, one_of(surface_questions))
data$surf <- rowMeans(surface_columns)


# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(data, one_of(strategic_questions))
data$stra <- rowMeans(strategic_columns)

# Exclude zeros exam points
data <- filter(data, Points > 0)

# The desirable columns
selected_colums <- c("gender", "Age", "attitude", "deep", "stra",
                     "surf", "Points")

# The data for analysis
data_analysis <- select(data, one_of(selected_colums))
dim(data_analysis) # 166 observations and 7 columns
str(data_analysis) # A data frame structure
head(data_analysis) # six first
tail(data_analysis) #six last

# Save the "data_analysis" data frame
write.csv(data_analysis, file = "learning2014.csv", row.names = FALSE)

# Read the data again
data_learning <- read.csv("learning2014.csv")
str(data_learning) # The structure is still the same
head(data_learning)
tail(data_learning)

