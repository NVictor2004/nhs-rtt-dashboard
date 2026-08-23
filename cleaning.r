library(tidyverse)
library(janitor)

data <- list.files(path = "data", full.names = TRUE) |>
  read_csv() |>
  clean_names() |>
  mutate(period = ceiling_date(my(period), unit = "month") - days(1))

starting <- data |>
  filter(rtt_part_type == "Part_3") |>
  select(
    period, provider_parent_org_code, provider_parent_name, provider_org_code,
    provider_org_name, commissioner_parent_org_code, commissioner_parent_name,
    commissioner_org_code, commissioner_org_name, treatment_function_code,
    treatment_function_name, total_all
  )

data <- data |>
  filter(rtt_part_type != "Part_3")

saveRDS(starting, "cache/cleaned_starting.rds")
saveRDS(data, "cache/cleaned_data.rds")
