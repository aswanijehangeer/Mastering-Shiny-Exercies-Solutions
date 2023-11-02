library(shiny)

ui <- fluidPage(
  sliderInput("year", "When should we deliver?", 
              min = as.Date("16-09-2020"), max = as.Date("23-09-2020"), 
              value = as.Date("17-09-2020"))
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)