# Information -------------------------------------------------------------
# Susanne Hamborg Larsen
# Introduction course
# January 23-25 2024

# Loading packages --------------------------------------------------------

library(tidyverse)
library(NHANES)


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
