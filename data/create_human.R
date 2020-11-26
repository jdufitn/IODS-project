# Josephine Dufitinema
# 19/11/2020 & 25/11/2020 
# RStudio Exercise #4 and Exercise #5

# NOTE: EXERCISE 5 - DATA WARNGLING --- SEE BELOW


# Read the "Human development" and "Gender inequality" data

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv",
               stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", 
                stringsAsFactors = F, na.strings = "..")

str(hd); str(gii) # Both are data frames with character and integer 
                  # variables
dim(hd) # 195 observations and 8 variables
dim(gii) # 195 observations and 10 variables

summary(hd) # Summary of hd data set
summary(gii) # summary of gii data set

# Rename the the variables with (shorter) descriptive names
colnames(hd) <- c("Rank", "Country", "Index", "Life_Expectancy", 
                  "Years_Education", "M_Years_Education",
                  "GNI_per_capita", "GNI_index")
str(hd) # names changed

colnames(gii) <- c("Rank", "Country", "Index", "Maternal_mortality",
                   "Adolescent_birth", "In_parliament", 
                   "F_education", "M_education", "F_labour", 
                   "M_labour")
str(gii) # names changed


# create two new variables in the gii data set

library(dplyr)
gii_new <- gii %>% # a new data frame
  mutate(ratio_gender = F_education / M_education,
         ratio_labour = F_labour / M_labour)
str(gii_new)


# Join together the two datasets

human <- gii_new %>% 
  inner_join(hd, by = "Country", suffix = c(".gii", ".hd"))
dim(human) # 195 observations and 19 variables

# save the joined data frame

write.csv(human, file = "human.csv", row.names = FALSE)

# Read the data again
human_joined <- read.csv("human.csv")
str(human_joined) # The structure is still the same
glimpse(human_joined)


#################### EXERCISE 5 - DATA WARNGLING ##############

# Load the 'human' data

# The data originates from the United Nations Development Programme
# (http://hdr.undp.org/en/content/human-development-index-hdi). 
# The data is retrieved from 
# (http://hdr.undp.org/en/content/human-development-index-hdi), 
# and it combines several indicators from most countries in the world. 
# Those indicators are grouped into Health and knowledge category and 
# Empowerment category.

# The variables names are as follows:

# Country = Country name
# Rank = HDI Rank (.hd for "Human development" data, .gii for "Gender inequality" data)
# Index = HDI index (.hd for "Human development" data, .gii for "Gender inequality" data)
# Maternal_mortality = Maternal Mortality Ratio 
# Adolescent_birth = Adolescent Birth Rate 
# In_parliament = Percetange of female representatives in parliament
# F_education = Proportion of females with at least secondary education
# M_education = Proportion of males with at least secondary education
# F_labour = Proportion of females in the labour force
# M_labour = Proportion of males in the labour force
# ratio_gender = F_education / M_education
# ratio_labour = F_labour / M_labour
# Life_Expectancy = Life expectancy at birth
# Years_Education = Expected years of schooling 
# M_Years_Education = Mean Years of Education 
# GNI_per_capita = Gross National Income (GNI) per Capita
# GNI_index = GNI per Capita Rank Minus HDI Rank

# Load the data from my local file

human <- read.csv("human.csv")
str(human) # the joined data have 195 observations and 19 variables
dim(human)

# Mutate the data

library(dplyr)
library(stringr)

human_new <- human %>%
mutate(GNI_per_capita =
         as.numeric(str_replace(GNI_per_capita, pattern=",", replace ="")))
str(human_new)  

# Exclude unneeded variables

# columns to keep
keep <- c("Country", "F_education", "ratio_labour", "Life_Expectancy", 
          "Years_Education", "GNI_per_capita", "Maternal_mortality",
          "Adolescent_birth", "In_parliament")

# select the 'keep' columns
human_new <- select(human_new, one_of(keep))


# Remove all rows with missing values
human_new <- na.omit(human_new)


# Remove the observations which relate to regions instead of countries

# look at the last 10 observations of human
tail(human_new, n = 10)

# define the last indice we want to keep
last <- nrow(human_new) - 7

# choose everything until the last 7 observations
human_data <- human_new[1:last, ]

# Define the row names of the data by the country 
# names and remove the country name column from the data.

# add countries as rownames
rownames(human_data) <- human_data$Country
head(human_data, n = 3)

# remove the country name column
human_data <- human_data[, !(colnames(human_data) == "Country")]
head(human_data, n = 3)
dim(human_data) # The data now have 155 observations and 8 variables.

# Save the human data in your data folder including the row names

write.csv(human_data, file = "human_data", row.names = TRUE)

# Read the data again
human_joined <- read.csv("human_data")
str(human_joined) # The structure is still the same
head(human_joined, n = 3)







