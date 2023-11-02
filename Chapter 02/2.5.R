#### Question ----

# Which of textOutput() and verbatimTextOutput() should each of the following render functions be paired with?
  
# renderPrint(summary(mtcars))
# 
# renderText("Good morning!")
# 
# renderPrint(t.test(1:5, 2:6))
# 
# renderText(str(lm(mpg ~ wt, data = mtcars)))


#### Answers ----

# renderPrint(summary(mtcars))	verbatimTextOutput()
# renderText("Good morning!")	textOutput()
# renderPrint(t.test(1:5, 2:6))	verbatimTextOutput()
# renderText(str(lm(mpg ~ wt, data = mtcars)))	verbatimTextOutput()