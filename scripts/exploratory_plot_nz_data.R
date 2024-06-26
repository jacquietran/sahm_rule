# Load libraries ---------------------------------------------------------------

library(readr)
library(here)
library(ggplot2)

# Also requires {dplyr}

# Read data into R -------------------------------------------------------------

unemployment_nz <- read_csv(
  file = here("data/tidy/NZL_HLF002101_20240626_070249_53.csv"),
  show_col_types = FALSE)

# Build plot -------------------------------------------------------------------

ggplot() +
  geom_line(
    data = unemployment_nz |>
      dplyr::filter(year > 2004),
    aes(x = timepoint_yyyymm, y = total_both_sexes, group = 1,
        colour = (quarterly_rate_minus_rolling_minimum >= 0.5)),
    linewidth = 3) +
  theme(
    legend.position = "none"
  )