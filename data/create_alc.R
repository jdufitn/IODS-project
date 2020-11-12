# Josephine Dufitinema
# 12/11/2020 
# RStudio Exercise #3
# Data source: UCI Machine Learning Repository (http://archive.ics.uci.edu/ml/dataset)
# Metadata available at: https://archive.ics.uci.edu/ml/datasets/Student+Performance
# The data are from two identical questionnaires related to secondary school student alcohol
# consumption in Portugal. 

# The two .csv files (student-mat.csv) and (student-por.csv) are
# moved to the data folder.
# We can also To download, extract, and import a zipped data file 
# in R, by doing the following:
#    - Create a temporary file to store the file to be downloaded:
#      temp <- tempfile()
#    - Download the file from the url: download.file("file url",temp)
#    - Extract the file from temp file and read the data using
#      read.table: data <- read.table(unz(temp, "file1.dat"))
#    - Remove the temporary file: unlink(temp)

# Read the two .csv files

math <- read.table("student-mat.csv", sep=";", header=TRUE)
por <- read.table("student-por.csv", sep=";", header=TRUE)

str(math); str(por) # Both are data frames with character and integer 
                   # variables
dim(math) # 395 observations and 33 variables
dim(por) # 649 observations and 33 variables


# Join the two data sets

# Define own id for both data sets
library(dplyr)
por_id <- por %>% mutate(id=1000+row_number()) # Adds a new column "id"
math_id <- math %>% mutate(id=2000+row_number()) # Adds a new column "id"

# check out the column names
colnames(por_id)
colnames(math_id)

# Which columns vary in data sets
free_cols <- c("id","failures","paid","absences","G1","G2","G3")

# The rest of the columns are common identifiers used 
# for joining the datasets
join_cols <- setdiff(colnames(por_id),free_cols)

pormath_free <- por_id %>% bind_rows(math_id) %>% 
                select(one_of(free_cols))
head(pormath_free, n = 3)
tail(pormath_free, n = 3)


# Combine data sets to one long data
#   NOTE! There are NO 382 but 370 students that belong to both data sets
#         Original joining/merging example is erroneous!

pormath <- por_id %>% 
  bind_rows(math_id) %>%
# Aggregate data (more joining variables than in the example)  
group_by(.dots=join_cols) %>%  
# Calculating required variables from two obs  
   summarise(                                                           
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     #  Rounded mean for numerical
    paid=first(paid),                   #    and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
)%>%
  
# Remove lines that do not have exactly one obs from both datasets
# There must be exactly 2 observations found in order to joining be succesful
# In addition, 2 obs to be joined must be 1 from por and 1 from math
# (id:s differ more than max within one dataset (649 here))
  filter(n==2, id.m-id.p>650) %>%  
  # Join original free fields, because rounded means or first values may not be relevant
  inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
  inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m")) %>%
  # Calculate other required variables  
  ungroup %>% mutate(
    alc_use = (Dalc + Walc) / 2, # alc_use combines weekday and weekend alcohol use
    high_use = alc_use > 2, # TRUE for alc_use > 2, FALSE otherwise
    cid=3000+row_number()
)

# check out the structure of the joined data
str(pormath) #  A tibble (data frame) with 370 obs and 51 variables
glimpse(pormath)

# NOTE: note that for variables failures, paid, absences, G1, G2, 
#       and G3 there are also variables with extra .p and .m in 
#       their names containing the original values from both datasets 

# Consider combining them: 
# If the columns are numeric, take rowMeans(),
# otherwise add the first column vector to the pormath data frame
# We use "If-else" structure

# Columns with extra in the data set
extra_cols <- c("failures","paid","absences","G1","G2","G3")

# create a new data frame with only the joined columns
# common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus",
             "Medu","Fedu","Mjob","Fjob","reason","nursery","internet",
             "alc_use", "high_use", "guardian", "traveltime", "studytime",
             "schoolsup", "famsup", "activities", "higher", "romantic",
             "famrel", "freetime", "health", "goout", "Walc", "Dalc")

pormath_joined <- select(pormath, one_of(join_by))

# for every column name in column extra...
for(column_name in extra_cols) {
  # select two columns from 'pormath' with the same original name
  two_columns <- select(pormath, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    pormath_joined[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    pormath_joined[column_name] <- first_column
  }
}

# glimpse at the new combined data
glimpse(pormath_joined) # 370 observations with 35 variables.


# Save the data to the "data" folder.

write.csv(pormath_joined, file = "pormath.csv", row.names = FALSE)

# Read the data again
data_joined <- read.csv("pormath.csv")
str(data_joined) # The structure is still the same
glimpse(data_joined)


















