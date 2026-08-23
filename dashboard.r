library(tidyverse)
library(shiny)

data <- readRDS("cache/processed_data.rds")
maximum <- max(data$people)

ui <- fluidPage(
  titlePanel("NHS Referral to Treatment (RTT) Waiting Times"),
  sidebarLayout(
    sidebarPanel(
      selectInput("period", "Select Time Period:",
        choices = unique(data$period)
      )
    ),
    mainPanel(
      plotOutput("colGraph"),
      plotOutput("boxPlot")
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
        title = "The Number of People waiting for each length of time"
      )
  })

  output$boxPlot <- renderPlot({
    data |>
      filter(period == input$period) |>
      ggplot(aes(x = week_numeric, y = "", weight = people)) +
      geom_boxplot() +
      scale_x_continuous(breaks = seq(0, 105, by = 2)) +
      labs(x = "Number of Weeks", y = "")
  })
}

shinyApp(ui = ui, server = server)
