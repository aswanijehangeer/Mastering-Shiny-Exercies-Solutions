
library(shiny)

ui <- fluidPage(
  titlePanel("Two Plots"),
  fluidRow(
    column(width = 6, plotOutput("plot1")),
    column(width = 6, plotOutput("plot2"))
  ),
  fluidRow(
    column(width = 12,
           numericInput("input1", "Input 1:", 2, min = 1, max = 100),
           numericInput("input2", "Input 2:", 50, min = 1, max = 100)
    )
  )
)

server <- function(input, output, session) {
  # Plot 1
  output$plot1 <- renderPlot({
    plot(1:100, runif(100))
  })
  
  # Plot 2
  output$plot2 <- renderPlot({
    plot(1:100, runif(100))
  })
}

shinyApp(ui, server)
