# Load libraries ---------------------------------------------------------------

library(readr)
library(here)
library(dplyr)
library(janitor)
library(tidyr)
library(glue)
library(zoo)

# Read data into R -------------------------------------------------------------

# Source: Stats NZ Household Labour Force Survey
# Table: Labour Force Status by Sex: Seasonally Adjusted (Qrtly-Mar/Jun/Sep/Dec)
# Up to 2024 Q1

unemployment_raw <- read_csv(
  here("data/raw/NZL_HLF002101_20240626_070249_53.csv"),
  skip = 1, show_col_types = FALSE)

# Tidy data --------------------------------------------------------------------

unemployment_tidy <- unemployment_raw %>%
  clean_names() %>%
  filter(!is.na(male)) %>%
  filter(!is.na(x1)) %>%
  rename(timepoint = x1) %>%
  mutate(
    across(
      c(male, female, total_both_sexes), as.numeric)) %>%
  separate_wider_position(
    cols = timepoint,
    widths = c(year = 4, quarter = 2)) %>%
  mutate(
    quarter_as_mm_dd = case_when(
      quarter == "Q1" ~ "03",
      quarter == "Q2" ~ "06",
      quarter == "Q3" ~ "09",
      quarter == "Q4" ~ "12"),
    timepoint_yyyymm = glue("{year}{quarter_as_mm_dd}"),
    # Return 12-month rolling minimum
    rolling_minimum = -rollmax(
      x = -total_both_sexes,
      k = 4,
      align = "right",
      fill = NA),
    # Flag records where the Sahm rule is triggered
    quarterly_rate_minus_rolling_minimum = total_both_sexes - rolling_minimum,
    sahm_rule_triggered = case_when(
      quarterly_rate_minus_rolling_minimum >= 0.5 ~ TRUE,
      TRUE                                        ~ FALSE)) %>%
  select(-quarter_as_mm_dd)

# Save to file -----------------------------------------------------------------

write.csv(
  unemployment_tidy,
  file = here("data/tidy/NZL_HLF002101_20240626_070249_53.csv"),
  row.names = FALSE
  )
