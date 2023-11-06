library(shiny)
library(shinyjs)

ui <- fluidPage(
  useShinyjs(),  # Initialize shinyjs
  
  selectInput("type", "Type", c("slider", "numeric")),
  
  # Numeric input (hidden by default)
  numericInput("n_numeric", "n (Numeric)", value = 0, min = 0, max = 100),
  
  # Slider input (hidden by default)
  sliderInput("n_slider", "n (Slider)", value = 0, min = 0, max = 100),
  
  actionButton("update_values", "Update Values"),
  
  verbatimTextOutput("selected_value")
)

server <- function(input, output, session) {
  observeEvent(input$type, {
    if (input$type == "numeric") {
      shinyjs::hide("n_slider")
      shinyjs::show("n_numeric")
    } else if (input$type == "slider") {
      shinyjs::hide("n_numeric")
      shinyjs::show("n_slider")
    }
  })
  
  values <- reactiveValues(
    n_numeric = 0,
    n_slider = 0
  )
  
  observe({
    if (input$type == "numeric") {
      values$n_numeric <- input$n_numeric
    } else if (input$type == "slider") {
      values$n_slider <- input$n_slider
    }
  })
  
  output$selected_value <- renderText({
    if (input$type == "numeric") {
      values$n_numeric
    } else if (input$type == "slider") {
      values$n_slider
    }
  })
  
  observeEvent(input$update_values, {
    if (input$type == "numeric") {
      updateNumericInput(session, "n_numeric", value = values$n_numeric)
    } else if (input$type == "slider") {
      updateSliderInput(session, "n_slider", value = values$n_slider)
    }
  })
}

shinyApp(ui, server)
