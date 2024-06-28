# Load libraries ---------------------------------------------------------------

library(readxl)
library(here)
library(dplyr)
library(janitor)
library(zoo)

# Also requires {stringr}

# Read data into R -------------------------------------------------------------

# Source: Australian Bureau of Statistics Labour Force Survey
# Table: Labour force status by Sex, Australia - Trend, Seasonally adjusted and Original
# Up to 2024-05 (May)
# https://www.abs.gov.au/statistics/labour/employment-and-unemployment/labour-force-australia/latest-release#data-downloads

unemployment_raw <- read_excel(
  here("data/raw/AUS_6202001.xlsx"),
  sheet = "Data1")

# Tidy data --------------------------------------------------------------------

unemployment_tidy <- unemployment_raw %>%
  clean_names() %>%
  filter(!is.na(as.numeric(as.character(x1)))) %>%
  select(
    x1, ends_with("_66")) %>%
  rename(
    timepoint_yyyymm = x1,
    unemployment_rate = unemployment_rate_persons_66) %>%
  mutate(
    unemployment_rate = as.numeric(unemployment_rate),
    timepoint_yyyymm = format(
      as.Date(
        as.numeric(timepoint_yyyymm), origin = "1899-12-30"),
      "%Y-%m"),
    year = as.numeric(stringr::str_sub(timepoint_yyyymm, start = 1, end = 4)),
    # Return 12-month rolling minimum
    rolling_minimum = -rollmax(
      x = -unemployment_rate,
      k = 12,
      align = "right",
      fill = NA),
    # Flag records where the Sahm rule is triggered
    quarterly_rate_minus_rolling_minimum = unemployment_rate - rolling_minimum,
    sahm_rule_triggered = case_when(
      quarterly_rate_minus_rolling_minimum >= 0.5 ~ TRUE,
      TRUE                                        ~ FALSE))

# Save to file -----------------------------------------------------------------

write.csv(
  unemployment_tidy,
  file = here("data/tidy/AUS_6202001.csv"),
  row.names = FALSE
  )
