library(testthat)

starting <- readRDS("cache/cleaned_starting.rds")
data <- readRDS("cache/cleaned_data.rds")

test_that("Cleaned datasets contain no NA values", {
  expect_false(anyNA(starting))
  expect_false(anyNA(data))
})
