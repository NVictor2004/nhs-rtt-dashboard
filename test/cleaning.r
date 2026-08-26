library(testthat)
library(dplyr)

# Load cleaned datasets
starting <- readRDS("cache/cleaned_starting.rds")
data <- readRDS("cache/cleaned_data.rds")

# The cleaned datasets should not contain NA values
test_that("Cleaned datasets contain no NA values", {
  expect_false(anyNA(starting))
  expect_false(anyNA(data))
})

# All patient counts should be non-negative
test_that("All patient counts are non-negative", {
  expect_true(all(select(data, gt_00_to_01_weeks_sum_1:total_all) >= 0))
  expect_true(all(starting$total_all >= 0))
})

# All patient counts sum correctly
test_that("All patient counts sum correctly", {
  manual_total <-
    rowSums(select(data, gt_00_to_01_weeks_sum_1:gt_104_weeks_sum_1))
  manual_total_all <- data$total + data$patients_with_unknown_clock_start_date

  expect_true(all(manual_total == data$total))
  expect_true(all(manual_total_all == data$total_all))
})
