library(shiny)
library(gapminder)


continents <- unique(gapminder$continent)

ui <- fluidPage(
  selectInput("continent", "Continent", choices = c("", as.character(continents))), 
  selectInput("country", "Country", choices = NULL),
  tableOutput("data")
)

server <- function(input, output, session) {
  
  selected_data <- reactive({
    if(input$continent %in% continents) {
      gapminder %>% 
        filter(continent == input$continent)
    } else {
      gapminder
    }
  })
  
  observeEvent(input$continent, {
    updateSelectInput(session, "country", "Country",
                      choices = selected_data() %>% 
                        select(country) %>%
                        distinct())
  })
  
  output$data <- renderTable({ 
    selected_data() %>% 
      filter(country == input$country) 
  })
}

shinyApp(ui = ui, server = server)