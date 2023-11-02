library(shiny)

ui <- fluidPage(
  selectInput("citrus", "What is your favorite citrus fruit?",
              choices = list(
                "Orange" = list("Navel Orange", "Valencia Orange"),
                "Lemon" = list("Eureka Lemon", "Meyer Lemon"),
                "Grapefruit" = list("White Grapefruit", "Pink Grapefruit", "Ruby Red Grapefruit")
              )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)