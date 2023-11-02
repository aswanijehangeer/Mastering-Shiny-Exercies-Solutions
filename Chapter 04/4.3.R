# Question ----

# Add an input control that lets the user decide how many rows to show in the summary tables.


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


### Shiny App ----

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
    column(2, actionButton("story", "Tell me a story")),
    column(10, textOutput("narrative"))
  )
)

server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  
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
  
  output$narrative <- renderText({
    input$story
    selected() %>% pull(narrative) %>% sample(1)
  })
}

shinyApp(ui, server)