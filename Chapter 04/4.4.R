### Question ----

# Provide a way to step through every narrative systematically with forward and backward buttons.

# remotes::install_github("hadley/neiss")
library(tidyverse)
library(neiss)
library(shiny)
library(forcats)

top_prod <- injuries %>%
  filter(trmt_date >= as.Date("2017-01-01"), trmt_date < as.Date("2018-01-01")) %>%
  count(prod1, sort = TRUE) %>%
  filter(n > 5 * 365)

injuries <- injuries %>%
  filter(trmt_date >= as.Date("2017-01-01"), trmt_date < as.Date("2018-01-01")) %>%
  semi_join(top_prod, by = "prod1") %>%
  mutate(age = floor(age), sex = tolower(sex), race = tolower(race)) %>%
  filter(sex != "unknown") %>%
  select(trmt_date, age, sex, race, body_part, diag, location, prod_code = prod1, weight, narrative)

products <- products %>%
  semi_join(top_prod, by = c("code" = "prod1")) %>%
  rename(prod_code = code) 

population <- population %>%
  filter(year == 2017) %>%
  select(-year) %>%
  rename(population = n)


count_top <- function(df, var, n = 5) {
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}

ui <- fluidPage(
  fluidRow(
    column(8, selectInput("code", "Product",
                          choices = setNames(products$prod_code, products$title),
                          width = "100%")
    ),
    column(2, numericInput("rows", "Number of Rows",
                           min = 1, max = 10, value = 5)),
    column(2, selectInput("y", "Y Axis", c("rate", "count")))
  ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  ),
  fluidRow(
    column(2, actionButton("prev_story", "Previous story")),
    column(2, actionButton("next_story", "Next story")),
    column(8, textOutput("narrative"))
  )
)

server <- function(input, output, session) {
  selected <- reactive(injuries %>% 
                         filter(prod_code == input$code))
  
  # Find the maximum possible of rows.
  max_no_rows <- reactive(
    max(length(unique(selected()$diag)),
        length(unique(selected()$body_part)),
        length(unique(selected()$location)))
  )
  
  # Update the maximum value for the numericInput based on max_no_rows().
  observeEvent(input$code, {
    updateNumericInput(session, "rows", max = max_no_rows())
  })
  
  table_rows <- reactive(input$rows - 1)
  
  output$diag <- renderTable(
    count_top(selected(), diag, n = table_rows()), width = "100%")
  
  output$body_part <- renderTable(
    count_top(selected(), body_part, n = table_rows()), width = "100%")
  
  output$location <- renderTable(
    count_top(selected(), location, n = table_rows()), width = "100%")
  
  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })
  
  output$age_sex <- renderPlot({
    if (input$y == "count") {
      summary() %>%
        ggplot(aes(age, n, colour = sex)) +
        geom_line() +
        labs(y = "Estimated number of injuries") +
        theme_grey(15)
    } else {
      summary() %>%
        ggplot(aes(age, rate, colour = sex)) +
        geom_line(na.rm = TRUE) +
        labs(y = "Injuries per 10,000 people") +
        theme_grey(15)
    }
  })
  
  # Store the maximum posible number of stories.
  max_no_stories <- reactive(length(selected()$narrative))
  
  # Reactive used to save the current position in the narrative list.
  story <- reactiveVal(1)
  
  # Reset the story counter if the user changes the product code. 
  observeEvent(input$code, {
    story(1)
  })
  
  # When the user clicks "Next story", increase the current position in the
  # narrative but never go beyond the interval [1, length of the narrative].
  # Note that the mod function (%%) is keeping `current`` within this interval.
  observeEvent(input$next_story, {
    story((story() %% max_no_stories()) + 1)
  })
  
  # When the user clicks "Previous story" decrease the current position in the
  # narrative. Note that we also take advantage of the mod function.
  observeEvent(input$prev_story, {
    story(((story() - 2) %% max_no_stories()) + 1)
  })
  
  output$narrative <- renderText({
    selected()$narrative[story()]
  })
}

shinyApp(ui, server)