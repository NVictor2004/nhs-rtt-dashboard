library(tidyverse)

# Process the cleaned data
data <- readRDS("data/processed/cleaned_data.rds") |>
  # Filter for the data on incomplete pathways across all types of treatment
  filter(treatment_function_code == "C_999") |>
  filter(rtt_part_type == "Part_2") |>
  # Sum the waiting list data for each period across all NHS providers
  # Column names are transformed to increase readability
  summarise(
    .by = c(period),
    # The column names `gt_00_to_01_weeks_sum_1` to `gt_103_to_104_weeks_sum_1`
    # are transformed into `0-1` to `103-104`
    across(
      gt_00_to_01_weeks_sum_1:gt_103_to_104_weeks_sum_1,
      sum,
      .names =
        "{str_replace(.col, '^gt_0*(\\\\d+)_to_0*(\\\\d+)_.*$', '\\\\1-\\\\2')}"
    ),
    `>104` = sum(gt_104_weeks_sum_1),
    total = sum(total),
    unknown_start_date = sum(patients_with_unknown_clock_start_date),
    total_all = sum(total_all)
  ) |>
  pivot_longer(
    cols = `0-1`:`>104`,
    names_to = "week",
    values_to = "people",
    names_transform = list(week = fct_inorder),
  ) |>
  # Create the `week_numeric` column to store the midpoint of each week interval
  # The value for the open ended interval (>104) is set to 104.5
  mutate(
    week_str = as.character(week),
    start_num = as.numeric(stringr::str_extract(week_str, "\\d+(?=-)")),
    end_num = as.numeric(stringr::str_extract(week_str, "(?<=-)\\d+")),
    week_numeric =
      ifelse(week_str == ">104", 104.5, (start_num + end_num) / 2)
  ) |>
  select(-week_str, -start_num, -end_num)

# Save the processed data to disk
saveRDS(data, "data/processed/processed_data.rds")
