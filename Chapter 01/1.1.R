library(shiny)

ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greetings")
)

server <- function(input, output, session) {
  output$greetings <- renderText({
    paste("Hello", input$name)
  })
}

shinyApp(ui, server)