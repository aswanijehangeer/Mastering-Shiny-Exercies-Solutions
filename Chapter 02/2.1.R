library(shiny)

ui <- fluidPage(
  textInput("name", "Your name", placeholder = "Your name")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)