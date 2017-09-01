

library(shiny)



## sliders for interest rate, and loan payment period in years
# Borrowed amount is numeric input
# output is a graph
shinyUI(pageWithSidebar(
  headerPanel("The Loan Visualizer"),
  sidebarPanel(
    h2("Please use the controls"),
    p(" to enter the amount of the loan, interest rate, and term in years"),
    p(" Click the Update Graph button when the loan parameters have been set"),
    br(),br(),
    numericInput('P', ' Loan Amount in $', 1000, min = 500, step = 100),
    sliderInput('I', 'interest rate',value = 5.5, min = 1, max = 12, step =  0.05),
    sliderInput('L', 'loan payment period in years',value = 10, min = 1, max = 40, step =  1),
    submitButton('Update Graph')
  ),
  mainPanel(
    plotOutput('newPlot')
  )
))


