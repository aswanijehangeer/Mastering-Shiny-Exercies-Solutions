library(shiny)

ui <- function(request){
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        bookmarkButton(),
        fileInput("file", "Choose CSV File", multiple = TRUE,accept = ".csv")
      ),
      mainPanel(
        tableOutput("contents")
      )
    )
  )
}


server <- function(input, output) {
  
  # create reactive of input file
  data <- reactive({
    req(input$file)
    read.csv(input$file$datapath)
  })
  
  # display head
  output$contents <- renderTable( head(data()) )
  
  # set the state to the df reactive
  onBookmark(function(state){
    state$values$data <- data()
  })
  
  # on restore set df to the state
  onRestore(function(state){
    data <- reactive(state$values$data)
  })
  enableBookmarking(store="server")
}

shinyApp(ui, server)