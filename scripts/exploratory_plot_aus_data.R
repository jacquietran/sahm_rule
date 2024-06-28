# Load libraries ---------------------------------------------------------------

library(readr)
library(here)
library(ggplot2)

# Also requires {dplyr}

# Read data into R -------------------------------------------------------------

unemployment_aus <- read_csv(
  file = here("data/tidy/AUS_6202001.csv"),
  show_col_types = FALSE)

# Build plot -------------------------------------------------------------------

ggplot() +
  geom_line(
    data = unemployment_aus |>
      dplyr::filter(year > 2004),
    aes(x = timepoint_yyyymm, y = unemployment_rate, group = 1,
        colour = (quarterly_rate_minus_rolling_minimum >= 0.5)),
    linewidth = 3) +
  theme(
    legend.position = "none"
  )