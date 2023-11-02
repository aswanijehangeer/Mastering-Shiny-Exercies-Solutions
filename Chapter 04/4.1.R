#### App - Prototype ----

# The prototype application has a single input, input$code, which is used to generate the selected() reactive. This reactive is used directly in 3 outputs, output$diag, output$body_part, and output$location, and it is also used indirectly in the output$age_sex plot via the summary() reactive.


#### App - Rate vs Count ----

# Building on the prototype, we create a second input input$y which is used along with the summary() reactive to create the output$age_sex plot.


#### App ----

# Building on the application once more, we create an output$narrative that depends on the selected() reactive and a new input, input$story.