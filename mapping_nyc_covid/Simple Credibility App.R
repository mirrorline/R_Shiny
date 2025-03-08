#Here is a simple app to test the credibility of two parameters given..
#..a credibility factor


library(shiny)

# Bayesian Credibility Function
calculate_credibility <- function(factor1, factor2, z) {
  # Replace this with your Bayesian Credibility calculation logic
  # Example: Credibility = (Factor1 + Factor2 + Factor3) / 3
 
  credibility <- (factor1 * z + factor2 * (1 - z))
  return(credibility)
}

# Define UI
ui <- fluidPage(
  titlePanel("Bayesian Credibility Calculator"),
  sidebarLayout(
    sidebarPanel(
      numericInput("factor1", "Factor 1:", value = 0),
      numericInput("factor2", "Factor 2:", value = 0),
      sliderInput("z", "Credibility Factor:", value = 0.5, max=1, min=0,step = 0.01),
      actionButton("calculateButton", "Calculate"),
      br(),
      helpText("Enter values for the two factors and the z value and click 'Calculate'.")
    ),
    mainPanel(
      textOutput("credibilityOutput")
    )
  )
)

# Define server
server <- function(input, output) {
  output$credibilityOutput <- renderText({
    # Call the Bayesian Credibility function with user inputs
    credibility <- calculate_credibility(input$factor1, input$factor2, input$z)
    paste("The credibility is:", credibility)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
