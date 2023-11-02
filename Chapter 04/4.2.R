#### Question ----
# What happens if you flip fct_infreq() and fct_lump() in the code that reduces the summary tables?


#### Answer ----

# As in the book, we will use the datasets injuries, products, and population appearing here: https://github.com/hadley/mastering-shiny/blob/main/neiss/data.R.
# Flipping the order of fct_infreq() and fct_lump() will only change the factor levels order. In particular, the function fct_infreq() orders the factor levels by frequency, and the function fct_lump() also orders the factor levels by frequency but it will only keep the top n factors and label the rest as Other.