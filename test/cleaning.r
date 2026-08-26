library(testthat)

# Load cleaned datasets
starting <- readRDS("cache/cleaned_starting.rds")
data <- readRDS("cache/cleaned_data.rds")

# The cleaned datasets should not contain NA values
test_that("Cleaned datasets contain no NA values", {
  expect_false(anyNA(starting))
  expect_false(anyNA(data))
})
