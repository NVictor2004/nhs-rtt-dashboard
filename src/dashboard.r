library(tidyverse)
library(shiny)
library(shinydashboard)
library(matrixStats)

# Retrieve processed data from cache
data <- readRDS("../cache/processed_data.rds")

# Create the User Interface
ui <- fluidPage(
  titlePanel("NHS Referral to Treatment (RTT) Waiting Times"),
  sidebarLayout(
    # Create time period selector in a side panel
    sidebarPanel(
      selectInput("period", "Select Time Period:",
        choices =
          setNames(unique(data$period), format(unique(data$period), "%B %Y")),
        selected = max(data$period)
      ),
    ),
    # Create the graphs and key statistics in the main panel
    mainPanel(
      fluidRow(
        valueBoxOutput("median", width = 3),
        valueBoxOutput("total", width = 3),
        valueBoxOutput("under18weeks", width = 3),
        valueBoxOutput("under52weeks", width = 3)
      ),
      plotOutput("colGraph")
    )
  )
)

# Calculate maximum number of people in a single week interval
maximum <- max(data$people)

# Create the server logic
server <- function(input, output) {
  period_data <- reactive({
    data |>
      filter(period == input$period)
  })

  # Generating the bar chart
  output$colGraph <- renderPlot({
    period_data() |>
      ggplot(aes(x = week, y = people)) +
      geom_col() +
      scale_y_continuous(limits = c(0, maximum), labels = scales::comma) +
      scale_x_discrete(breaks = \(x) x[seq(1, length(x), 5)]) +
      labs(
        y = "Number of people",
        x = "Number of weeks",
        title = "The number of people waiting for each number of weeks"
      )
  })

  # Generating the box for the median waiting time (in weeks)
  output$median <- renderValueBox({
    period_data <- period_data()
    median <- weightedMedian(period_data$week_numeric, period_data$people)
    valueBox(
      value = round(median, 1),
      subtitle = "Median waiting time (weeks)"
    )
  })

  # Generating the box for the total number of people on the waiting list
  output$total <- renderValueBox({
    total <- period_data()[1, "total_all"]
    valueBox(
      value = round(total),
      subtitle = "Total number of people on the waiting list"
    )
  })

  # Generating the box for the proportion of people waiting less than 18 weeks
  output$under18weeks <- renderValueBox({
    under18weeks <- period_data() |>
      filter(week_numeric <= 18) |>
      summarise(under18 = sum(people), total = first(total_all))

    valueBox(
      value =
        paste0(
          round((under18weeks$under18 / under18weeks$total) * 100, 1),
          "%"
        ),
      subtitle = "Proportion of people waiting less than 18 weeks"
    )
  })

  # Generating the box for the proportion of people waiting less than 52 weeks
  output$under52weeks <- renderValueBox({
    under52weeks <- period_data() |>
      filter(week_numeric <= 52) |>
      summarise(under52 = sum(people), total = first(total_all))

    valueBox(
      value =
        paste0(
          round((under52weeks$under52 / under52weeks$total) * 100, 1),
          "%"
        ),
      subtitle = "Proportion of people waiting less than 52 weeks"
    )
  })
}

# Creating the Shiny app
shinyApp(ui, server)
