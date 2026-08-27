library(tidyverse)
library(janitor)

# Concatenate all CSV files in the `data` directory together
data <- list.files(path = "data/raw", full.names = TRUE) |>
  read_csv() |>
  # Clean the column names
  clean_names() |>
  # Convert the `period` column to the last day of the corresponding month
  mutate(period = ceiling_date(my(period), unit = "month") - days(1)) |>
  # If any organisation codes or names are missing, replace them with "UNKNOWN"
  mutate(across(
    provider_parent_org_code:commissioner_org_name,
    \(x) coalesce(x, "UNKNOWN")
  ))

# Create separate table for new RTT pathways
starting <- data |>
  filter(rtt_part_type == "Part_3") |>
  select(
    period:commissioner_org_name, treatment_function_code,
    treatment_function_name, total_all
  )

# Continue cleaning original dataset
data <- data |>
  # Remove the new RTT pathways
  filter(rtt_part_type != "Part_3") |>
  # Replace missing values
  mutate(
    across(
      c(gt_00_to_01_weeks_sum_1:gt_104_weeks_sum_1,
        patients_with_unknown_clock_start_date),
      \(x) coalesce(x, 0)
    ),
    total = coalesce(total, total_all - patients_with_unknown_clock_start_date)
  )

# Save both cleaned datasets
saveRDS(starting, "data/processed/cleaned_starting.rds")
saveRDS(data, "data/processed/cleaned_data.rds")
