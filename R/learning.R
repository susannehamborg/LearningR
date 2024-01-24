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


# EXERCISE ----------------------------------------------------------------


nhanes_small <- NHANES_small

nhanes_small %>%
  select(bp_sys_ave, education)

nhanes_small %>%
  rename(
    bp_sys = bp_sys_ave,
    bp_dia = bp_dia_ave
  )

# rewrite this:
select(nhanes_small, bmi, contains("age"))

# rewriting to tidy:
nhanes_small %>%
  select(bmi, contains("age"))


# rewrite this:
blood_pressure <- select(nhanes_small, starts_with("bp_"))
rename(blood_pressure, bp_systolic = bp_sys_ave)

# rewritten:
nhanes_small %>%
  select(starts_with("bp_")) %>%
  rename(bp_systolic = bp_sys_ave)


