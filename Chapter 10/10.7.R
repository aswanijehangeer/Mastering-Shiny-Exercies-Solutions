library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Customizable ggplot Geoms"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("show_histogram", "Show Histogram", value = FALSE),
      conditionalPanel(
        condition = "input.show_histogram",
        sliderInput("hist_binwidth", "Histogram Bin Width", min = 0.1, max = 2, value = 0.2, step = 0.1)
      ),
      checkboxInput("show_freqpoly", "Show Frequency Polygon", value = FALSE),
      conditionalPanel(
        condition = "input.show_freqpoly",
        sliderInput("freqpoly_binwidth", "Frequency Polygon Bin Width", min = 0.1, max = 2, value = 0.2, step = 0.1)
      ),
      checkboxInput("show_density", "Show Density", value = FALSE),
      conditionalPanel(
        condition = "input.show_density",
        sliderInput("density_bw", "Density Bandwidth", min = 0.1, max = 2, value = 0.5, step = 0.1)
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
    
    if (input$show_histogram) {
      gg <- gg + geom_histogram(binwidth = input$hist_binwidth)
    }
    
    if (input$show_freqpoly) {
      gg <- gg + geom_freqpoly(binwidth = input$freqpoly_binwidth)
    }
    
    if (input$show_density) {
      gg <- gg + geom_density(bw = input$density_bw)
    }
    
    gg
  })
}

shinyApp(ui, server)
