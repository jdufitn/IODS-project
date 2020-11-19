# Josephine Dufitinema
# 19/11/2020 
# RStudio Exercise #4

# Read the "Human development" and "Gender inequality" datas

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




