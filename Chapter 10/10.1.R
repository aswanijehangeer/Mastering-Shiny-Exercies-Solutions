library(shiny)

ui <- fluidPage(
  numericInput("year", "Year", value = 2020),
  dateInput("date", "Date")
)

server <- function(input, output, session) {
  observe({
    # selected year from the numeric input
    selected_year <- input$year
    
    # range of dates for the selected year
    start_date <- as.Date(paste(selected_year, "-01-01", sep = ""))
    end_date <- as.Date(paste(selected_year, "-12-31", sep = ""))
    
    #  date input to allow only dates in the selected year
    updateDateInput(session, "date", min = start_date, max = end_date)
  })
}

shinyApp(ui, server)
