library(tidyverse)

data <- readRDS("cache/cleaned_data.rds") |>
  filter(treatment_function_code == "C_999") |>
  filter(rtt_part_type == "Part_2") |>
  summarise(
    .by = c(period),
    across(
      gt_00_to_01_weeks_sum_1:gt_103_to_104_weeks_sum_1,
      sum,
      .names =
        "{str_replace(.col, '^gt_0*(\\\\d+)_to_0*(\\\\d+)_.*$', '\\\\1-\\\\2')}"
    ),
    `>104` = sum(gt_104_weeks_sum_1),
    total = sum(total),
    unknownStartDate = sum(patients_with_unknown_clock_start_date),
    totalAll = sum(total_all)
  ) |>
  pivot_longer(
    cols = `0-1`:`>104`,
    names_to = "week",
    values_to = "people",
    names_transform = list(week = fct_inorder),
  ) |>
  mutate(
    week_str = as.character(week),
    start_num = as.numeric(stringr::str_extract(week_str, "\\d+(?=-)")),
    end_num   = as.numeric(stringr::str_extract(week_str, "(?<=-)\\d+")),
    week_numeric =
      ifelse(week_str == ">104", 104.5, (start_num + end_num) / 2)
  ) |>
  select(-week_str, -start_num, -end_num)

saveRDS(data, "cache/processed_data.rds")
