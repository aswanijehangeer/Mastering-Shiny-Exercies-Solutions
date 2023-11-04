# Load necessary libraries
library(shiny)

# Define the UI for the Shiny app
ui <- fluidPage(
  titlePanel("t-Test App"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload a CSV file"),
      selectInput("variable", "Select a variable to perform t-test:", ""),
      actionButton("runTest", "Perform t-Test")
    ),
    mainPanel(
      verbatimTextOutput("testResult")
    )
  )
)

# Define the server for the Shiny app
server <- function(input, output, session) {
  
  # Read the uploaded CSV file
  data <- reactive({
    req(input$file)
    read.csv(input$file$datapath)
  })
  
  # Update the variable selection based on the uploaded file
  observe({
    if (!is.null(data())) {
      updateSelectInput(session, "variable", label = "Select a variable to perform t-test:",
                        choices = names(data()))
    }
  })
  
  # Perform t-test when the button is clicked
  observeEvent(input$runTest, {
    req(input$variable)
    var_to_test <- input$variable
    t_test_result <- t.test(data()[[var_to_test]])
    output$testResult <- renderPrint({
      paste("t-Test for", var_to_test, ":")
      t_test_result
    })
  })
}

# Run the Shiny app
shinyApp(ui, server)
