library(shiny)

ui <- fluidPage(
  sliderInput("number", "Select a number", 
              min = 0, max = 100, value = 25,
              step = 5, animate = TRUE)
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)