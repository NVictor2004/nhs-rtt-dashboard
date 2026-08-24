library(tidyverse)
library(shiny)
library(shinydashboard)
library(matrixStats)

data <- readRDS("cache/processed_data.rds")
maximum <- max(data$people)

ui <- fluidPage(
  titlePanel("NHS Referral to Treatment (RTT) Waiting Times"),
  sidebarLayout(
    sidebarPanel(
      selectInput("period", "Select Time Period:",
        choices =
          setNames(unique(data$period), format(unique(data$period), "%B %Y")),
        selected = max(data$period)
      ),

    ),
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

server <- function(input, output) {
  output$colGraph <- renderPlot({
    data |>
      filter(period == input$period) |>
      ggplot(aes(x = week, y = people)) +
      geom_col() +
      scale_y_continuous(limits = c(0, maximum), labels = scales::comma) +
      scale_x_discrete(breaks = function(x) x[seq(1, length(x), by = 5)]) +
      labs(
        y = "Number of People",
        x = "Number of Weeks",
        title = "The number of people waiting for each number of weeks"
      )
  })

  output$median <- renderValueBox({
    output <- data |>
      filter(period == input$period)
    median <- weightedMedian(output$week_numeric, output$people)
    valueBox(
      value = round(median, 1),
      subtitle = "Median waiting time (weeks)"
    )
  })

  output$total <- renderValueBox({
    output <- data |>
      filter(period == input$period) |>
      head(1)
    valueBox(
      value = round(output$totalAll),
      subtitle = "Total number of people on the waiting list"
    )
  })

  output$under18weeks <- renderValueBox({
    output <- data |>
      filter(period == input$period) |>
      filter(week_numeric <= 18) |>
      summarise(under18 = sum(people), total = first(totalAll))

    valueBox(
      value = paste0(round((output$under18 / output$total) * 100, 1), "%"),
      subtitle = "Proportion of people waiting less than 18 weeks"
    )
  })

  output$under52weeks <- renderValueBox({
    output <- data |>
      filter(period == input$period) |>
      filter(week_numeric <= 52) |>
      summarise(under52 = sum(people), total = first(totalAll))

    valueBox(
      value = paste0(round((output$under52 / output$total) * 100, 1), "%"),
      subtitle = "Proportion of people waiting less than 52 weeks"
    )
  })
}

shinyApp(ui = ui, server = server)
