library(shiny)
library(tidyverse)
library(openintro)

states <- unique(county$state)
counties <- unique(county$state)

ui <- fluidPage(
  selectInput("state", "State", choices = states),
  selectInput("county", "County", choices = NULL)
)


server <- function(input, output, session) {
  
  label <- reactive({
    switch(input$state,
           "Alaska" = "Burrough",
           "Louisiana" = "Parish",
           "County")
  })
  
  observeEvent( input$state, {
    updateSelectInput(session, "county", label = label(),
                      choices = county %>% 
                        filter(state == input$state) %>%
                        select(name) %>%
                        distinct())
  })
  
}


shinyApp(ui, server)