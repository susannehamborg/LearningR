# Information -------------------------------------------------------------
# Susanne Hamborg Larsen
# Introduction course
# January 23-25 2024

# Loading packages --------------------------------------------------------

library(tidyverse)
library(NHANES)
library(magrittr)



# Overview of dataset -----------------------------------------------------

# If you want to see the dataset in your environment (not nessesary, since it's built in in the NHANES package)
NHANES <- NHANES

# Tidyverse:
glimpse(NHANES)

# BaseR (less good):
str(NHANES)


# Select specific columns -------------------------------------------------

# Select only a few columns:
select(NHANES, ID, Gender, Age)

# Select all but some:
select(NHANES, -HeadCirc, -Pulse)

# Select columns starting/ending with   -> NB NOT case-sensitive
select(NHANES, ID, starts_with("BP"))
select(NHANES, ID, ends_with("Day"))

# select columns including a specific paragraph
select(NHANES, contains("Age")) # -> Not case-sensitive


# Rename ------------------------------------------------------------------

# Rename all column names:
NHANES_small <- rename_with(NHANES, snakecase::to_snake_case)
# do not include () after function to_snake_case, because we want to apply it on all columns

# Rename specific column:
NHANES_small <- rename(NHANES_small, sex = gender)
# rename(new name = old name)

# to see the dataset in another vindue, click in environment, or:
View(NHANES_small)



# Chaining the function with the pipe -------------------------------------

NHANES_small %>%
  colnames()

# shortcut for pipe: ctrl+shift+m

NHANES_phys <- NHANES_small %>%
  select(id, phys_active) %>%
  rename(physically_active = phys_active)


# Exercise ----------------------------------------------------------------


nhanes_small <- NHANES_small

# 1
nhanes_small %>%
  select(bp_sys_ave, education)

# 2
nhanes_small %>%
  rename(
    bp_sys = bp_sys_ave,
    bp_dia = bp_dia_ave
  )

# 3
# rewrite this:
select(nhanes_small, bmi, contains("age"))

# rewriting to tidy:
nhanes_small %>%
  select(bmi, contains("age"))


# 4
# rewrite this:
blood_pressure <- select(nhanes_small, starts_with("bp_"))
rename(blood_pressure, bp_systolic = bp_sys_ave)

# rewritten:
nhanes_small %>%
  select(starts_with("bp_")) %>%
  rename(bp_systolic = bp_sys_ave)


# Filtering data by row ---------------------------------------------------

# The filter() function takes a logic condition (TRUE or FALSE).
# As with the other functions, the first argument is the dataset and all others
# are the logical conditions that will apply to the row filtering.

filter(nhanes_small, phys_active == "No")
# OR
nhanes_small %>%
  filter(phys_active == "No")

# Participants who are physically active
nhanes_small %>%
  filter(phys_active != "No") %>%
  select(phys_active)

nhanes_small %>%
  filter(bmi == 25) %>%
  select(id, bmi)

nhanes_small %>%
  filter(bmi >= 25) %>%
  select(id, bmi)

# AND-operator: when you want to combine different values in a row (across columns)
# NB! or &, both sides must be TRUE in order for the combination to be TRUE.
#     For |, only one side needs to be TRUE in order for the combination to be TRUE.
#  BE CAREFUL WITH THIS, ESPECIALLY OR !
#  (if you only write a comma, then R sees it as AND)

TRUE & TRUE
TRUE & FALSE
FALSE & FALSE
TRUE | TRUE
TRUE | FALSE
FALSE | FALSE

nhanes_small %>%
  filter(bmi == 25 & phys_active == "No") %>%
  select(bmi, phys_active)

nhanes_small %>%
  filter(bmi == 25 | phys_active == "No") %>%
  select(bmi, phys_active)


# Arranging rows ----------------------------------------------------------

nhanes_small %>% # only for numerical and factor columns, not characters
  arrange(age)

nhanes_small %>%
  arrange(education) %>%
  select(education)

nhanes_small %>%
  arrange(desc(age)) # NB desc is also a function

# arrange by several columns
nhanes_small %>%
  arrange(age, education) %>%
  select(age, education)


# Transform or add columns ------------------------------------------------

nhanes_small %>%
  mutate(
    age = age * 12, # change age-column
    log_bmi = log(bmi)
  ) %>% # add new column, because the name is not in the dataset
  select(id, age, bmi, log_bmi)

nhanes_small %>%
  mutate(
    old = if_else(age >= 30, "Yes", "No")
  ) %>%
  select(age, old)



# Exercise ----------------------------------------------------------------

# 1. BMI between 20 and 40 with diabetes   # 616 observations
nhanes_small %>%
    # Format should follow: variable >= number or character
    filter(bmi >= 20 & bmi <= 40 & diabetes == "Yes")

# Pipe the data into mutate function and:
nhanes_modified <- nhanes_small %>% # Specifying dataset
    mutate(
        # 2. Calculate mean arterial pressure
        mean_arterial_pressure = ((2*bp_dia_ave) + bp_sys_ave) / 3,
        # 3. Create young_child variable using a condition
        young_child = if_else(age < 6, "Yes", "No")
    )



# Calculating summary statistics ----------------------------------------------------

nhanes_small %>%
    summarise(max_bmi = max(bmi))
#(if there are NA values, R cannot calculate max, mean etc. Need to exclude NA's from analysis)

nhanes_small %>%
    summarise(max_bmi = max(bmi, na.rm = TRUE))  # should be within the max function

result <- nhanes_small %>%
    summarise(max_bmi = max(bmi, na.rm = TRUE),
              min_bmi = min(bmi, na.rm = TRUE))



# Summary statistics by group -------------------------------------------------------

nhanes_small %>%
    group_by(diabetes) %>%
    summarise(mean_age = mean(age, na.rm = TRUE),
              mean_bmi = mean(bmi, na.rm = TRUE))

nhanes_small %>%
    filter(!is.na(diabetes)) %>%             # filter to select only rows, where diabtes is NOT NA
    group_by(diabetes) %>%
    summarise(mean_age = mean(age, na.rm = TRUE),
              mean_bmi = mean(bmi, na.rm = TRUE))

nhanes_small %>%
    filter(!is.na(diabetes), !is.na(phys_active)) %>%      # filter to select only rows, where diabtes is NOT NA
    group_by(diabetes, phys_active) %>%     # make groups with different combinations of diabetes and phys.activity
    summarise(mean_age = mean(age, na.rm = TRUE),
              mean_bmi = mean(bmi, na.rm = TRUE)) %>%
    ungroup()                               # always ungroup in the end, to not mess other things up ;)



# Saving dataset as a file ------------------------------------------------

readr::write_csv(nhanes_small, here::here("data/nhanes_small.csv"))















