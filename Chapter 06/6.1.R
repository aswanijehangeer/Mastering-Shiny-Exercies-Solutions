library(shiny)

ui <- fluidPage(
    column(width = 12,
           fluidRow(
             column(width = 4, 
                    sidebarPanel(
               h3("Sidebar"),
               textInput("input", "Enter some text")
             )),
             column(width = 8, 
                    mainPanel(
               h3("Main Panel"),
               textOutput("output")
             ))
           )
    )
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
