library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Customizable ggplot Geoms"),
  sidebarLayout(
    sidebarPanel(
      selectInput("geom_choice", "Select Geom",
                  choices = c("Histogram", "Frequency Polygon", "Density")),
      conditionalPanel(
        condition = "input.geom_choice == 'Histogram' || input.geom_choice == 'Frequency Polygon'",
        sliderInput("binwidth", "Bin Width", min = 0.1, max = 2, value = 0.2, step = 0.1)
      ),
      conditionalPanel(
        condition = "input.geom_choice == 'Density'",
        sliderInput("bw", "Bandwidth", min = 0.1, max = 2, value = 0.5, step = 0.1)
      )
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output) {
  output$plot <- renderPlot({
    gg <- ggplot(diamonds, aes(x = carat))
    
    if (input$geom_choice == "Histogram") {
      gg <- gg + geom_histogram(binwidth = input$binwidth)
    } else if (input$geom_choice == "Frequency Polygon") {
      gg <- gg + geom_freqpoly(binwidth = input$binwidth)
    } else if (input$geom_choice == "Density") {
      gg <- gg + geom_density(bw = input$bw)
    }
    
    gg
  })
}

shinyApp(ui, server)
