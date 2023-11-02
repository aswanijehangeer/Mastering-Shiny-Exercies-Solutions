library(shiny)

ui <- fluidPage(
  dataTableOutput("table")
)
server <- function(input, output, session) {
  output$table <- renderDataTable(mtcars, 
                                  options = list(
                                    searching = FALSE,
                                    ordering = FALSE,
                                    info = FALSE,
                                    paging = FALSE
                                  ))
}

shinyApp(ui, server)