message("Starting NHS Referral to Treatment (RTT) Waiting Times pipeline")

# Create cache directory if it does not already exist
if (!file.exists("cache")) {
  dir.create("cache")
}

# Start the pipeline

message("Gathering and cleaning data")
source("src/cleaning.r")

message("Running tests on cleaned dataset")
source("test/cleaning.r")

message("Processing cleaned dataset for dashboard generation")
source("src/processing.r")

message("Generating dashboard")
shiny::runApp("src/dashboard.r")
