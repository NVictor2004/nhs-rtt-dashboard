library(tidyverse)
library(janitor)

# Concatenate all CSV files in the `data` directory together
data <- list.files(path = "data", full.names = TRUE) |>
  read_csv() |>
  # Clean the column names
  clean_names() |>
  # Convert the `period` column to the last day of the corresponding month
  mutate(period = ceiling_date(my(period), unit = "month") - days(1))

# Create separate table for new RTT pathways
starting <- data |>
  filter(rtt_part_type == "Part_3") |>
  select(
    period:commissioner_org_name, treatment_function_code,
    treatment_function_name, total_all
  )

# Remove the main RTT pathways from the original dataset
data <- data |>
  filter(rtt_part_type != "Part_3")

# Save both cleaned datasets
saveRDS(starting, "cache/cleaned_starting.rds")
saveRDS(data, "cache/cleaned_data.rds")
