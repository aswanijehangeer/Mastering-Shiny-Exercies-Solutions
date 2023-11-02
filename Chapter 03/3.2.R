#### Question:

## Draw the reactive graph for the following server functions 

server1 <- function(input, output, session) {
  c <- reactive(input$a + input$b)
  e <- reactive(c() + input$d)
  output$f <- renderText(e())
}

server2 <- function(input, output, session) {
  x <- reactive(input$x1 + input$x2 + input$x3)
  y <- reactive(input$y1 + input$y2)
  output$z <- renderText(x() / y())
}

server3 <- function(input, output, session) {
  d <- reactive(c() ^ input$d)
  a <- reactive(input$a * 10)
  c <- reactive(b() / input$c) 
  b <- reactive(a() + input$b)
}

#### Answers ----


# Reactive graph for server1:
  
# For server1 we have the following objects:
#   
# inputs: input$a, input$b, and input$d
# reactives: c() and e()
# outputs: output$f
# 
# Inputs input$a and input$b are used to create c(), which is combined with input$d to create e(). The output depends only on e().



# For server2 we have the following objects:
#   
# inputs: input$y1, input$y2, input$x1, input$x2, input$x3
# reactives: y() and x()
# outputs: output$z
# 
# Inputs input$y1 and input$y2 are needed to create the reactive y(). In addition, inputs input$x1, input$x2, and input$x3 are required to create the reactive x(). The output depends on both x() and y()


# For server3 we have the following objects:
#   
# inputs: input$a, input$b, input$c, input$d
# reactives: a(), b(), c(), d()
# 
# As we can see below, a() relies on input$a, b() relies on both a() and input$b, and c() relies on both b() and input$c. The final output depends on both c() and input$d.









