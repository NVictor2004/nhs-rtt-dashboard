message("Starting NHS Referral to Treatment (RTT) Waiting Times pipeline")

# Create cache directory if it does not already exist
if (!file.exists("data/processed")) {
  dir.create("data/processed")
}

# Start the pipeline

message("Gathering and cleaning data")
source("R/cleaning.R")

message("Running tests on cleaned dataset")
source("tests/test_cleaning.R")

message("Processing cleaned dataset for dashboard generation")
source("R/processing.R")

message("Generating dashboard")
shiny::runApp("R/dashboard.R")
