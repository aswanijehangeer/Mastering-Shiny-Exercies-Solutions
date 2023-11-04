# Load necessary libraries
library(shiny)
library(ggplot2)
library(png)
library(Cairo)

# Define UI for the Shiny app
ui <- fluidPage(
  titlePanel("Histogram Generator"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload a CSV file"),
      selectInput("variable", "Select a Variable:", ""),
      selectInput("format", "Select Output Format:",
                  c("PNG" = "png", "PDF" = "pdf", "SVG" = "svg")),
      downloadButton("downloadPlot", "Download Histogram")
    ),
    mainPanel(
      plotOutput("histogram")
    )
  )
)

# Define server for the Shiny app
server <- function(input, output, session) {
  
  # Read the uploaded CSV file
  data <- reactive({
    req(input$file)
    read.csv(input$file$datapath)
  })
  
  # Update the variable selection based on the uploaded file
  observe({
    if (!is.null(data())) {
      updateSelectInput(session, "variable", label = "Select a Variable:",
                        choices = names(data()))
    }
  })
  
  # Create the histogram plot
  output$histogram <- renderPlot({
    req(input$variable)
    var_to_plot <- input$variable
    ggplot(data(), aes(x = data()[[var_to_plot]])) +
      geom_histogram() +
      labs(x = var_to_plot, y = "Frequency", title = "Histogram") +
      theme_minimal()
  })
  
  # Download the histogram in the selected format
  observeEvent(input$downloadPlot, {
    req(input$variable)
    var_to_plot <- input$variable
    plot <- ggplot(data(), aes(x = data()[[var_to_plot]])) +
      geom_histogram() +
      labs(x = var_to_plot, y = "Frequency", title = "Histogram") +
      theme_minimal()
    
    output_format <- input$format
    
    if (output_format == "pdf") {
      ggsave("histogram.pdf", plot, device = cairo_pdf, width = 8, height = 6)
    } else if (output_format == "svg") {
      ggsave("histogram.svg", plot, device = "svg", width = 8, height = 6)
    } else {
      ggsave("histogram.png", plot, device = "png", width = 800, height = 600)
    }
  })
}

# Run the Shiny app
shinyApp(ui, server)
