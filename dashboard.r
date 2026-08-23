library(tidyverse)
library(shiny)

data <- readRDS("cache/processed_data.rds")

ui <- fluidPage(
  titlePanel("Dashboard"),
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
      geom_col()
  })

  output$boxPlot <- renderPlot({
    data |>
      filter(period == input$period) |>
      ggplot(aes(x = week_numeric, weight = people)) +
      geom_boxplot()
  })
}

shinyApp(ui = ui, server = server)
