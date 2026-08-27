# NHS Referral to Treatment (RTT) Waiting Times Dashboard

This is a Reproducible Analytical Pipeline (RAP) implemented in R. It takes data on NHS RTT waiting times from their [website](https://www.england.nhs.uk/statistics/statistical-work-areas/rtt-waiting-times/). The data is cleaned and tested, before being used to create an R Shiny dashboard. The dashboard aims to make it easy for the public to quickly see key statistics and graphs on RTT waiting times for each month. 

## Prerequisites

To run this pipeline, you must have R installed with the R packages `tidyverse`, `janitor`, `shiny`, `shinydashboard`, `matrixStats` and `testthat`.

## How to run the pipeline

1. Clone the repository
2. Create a folder called `data` in the project root folder, and create a folder called `raw` inside the `data` folder
3. Download the CSV files from the NHS RTT waiting times [website](https://www.england.nhs.uk/statistics/statistical-work-areas/rtt-waiting-times/) that you want to use in your analysis
4. Move the files into the `data/raw` folder
5. Run `Rscript run_pipeline.R` in the project root folder
6. Open the dashboard in your web browser at the specified URL
