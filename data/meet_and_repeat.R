# Josephine Dufitinema
# 03/12/2020 
# RStudio Exercise #6

# Load the data sets (BPRS and RATS)

# libraries
library(dplyr)
library(ggplot2)
library(tidyr)

# BPRS data set
BPRS <- read.table(file = 
        "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",
        sep = " ", header = TRUE)
head(BPRS)
tail(BPRS)
colnames(BPRS)
str(BPRS)
summary(BPRS)

# Comment: BPRS data set is in a wider format as weekly recorded of 
#          BPRS measurements from 40 subjects are individual variables.

# RATS data set
RATS <- read.table(file = 
         "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",
         sep = "\t", header = TRUE)
head(RATS)
tail(RATS)
colnames(RATS)
str(RATS)
summary(RATS)

# Comment: RATS data set is in a wider format as rats weekly recorded
#          body weights are individual variables.


# Convert the categorical variables of both data sets to factors

# BPRS data set: Variables treatment and subject
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)  
  
glimpse(BPRS)

# RATS data set: variables ID and Group
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

glimpse(RATS)

# Convert the data sets to long form -- the use of gather()

# BPRS data set: Add a week variable
BPRSL <- gather(BPRS, key = weeks, value = bprs, week0:week8)%>%
  mutate(week = as.integer(substr(weeks, 5,5)))

glimpse(BPRSL)
head(BPRSL)
tail(BPRSL)
str(BPRSL)
colnames(BPRSL)
summary(BPRSL)

# Comment: BPRSL is converted into long format. That is from 40 
#          observations to 360, and from 11 variables to 5.
#          The aim is to have the weeks as values of a new 
#          variable week. Hence, the BPLS value is recorded
#          for each week, which makes the analysis and the 
#          graphical presentation of the data easier. 


# RATS data set: add a Time variable
RATSL <- gather(RATS, key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD, 3,4)))
glimpse(RATSL)
head(RATSL)
tail(RATSL)
str(RATSL)
colnames(RATSL)
summary(RATSL)

# Comment: RATSL is converted into long format. That is from 16 
#          observations to 176, and from 13 variables to 5.
#          The aim is to have the rats weights as values of a new 
#          variable Weight. Hence, the BPLS value is recorded
#          for each time, which makes the analysis and the 
#          graphical presentation of the data easier. 


# Save the BPRSL data set
write.csv(BPRSL, file = "BPRSL")

# Read it again
BPRSL_test <- read.csv("BPRSL")
glimpse(BPRSL_test) # The structure is still the same

# Save the RATSL data set
write.csv(RATSL, file = "RATSL")

# Read it again
RATSL_test <- read.csv("RATSL")
glimpse(RATSL_test) # The structure is still the same




