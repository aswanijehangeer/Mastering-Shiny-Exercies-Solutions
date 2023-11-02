#### Question ----

# Why will this code fail?
  
var <- reactive(df[[input$var]])
range <- reactive(range(var(), na.rm = TRUE))
  
# Why are range() and var() bad names for reactive?



#### Answer ----

# The code will fail because there are already two functions named var() and range() in the R language. When you create reactive expressions with the same names as existing functions, R will not be able to distinguish between the two. This will result in an error.

var_reactive <- reactive(df[[input$var]])
range_reactive <- reactive(range(var_reactive(), na.rm = TRUE))

# This will work.