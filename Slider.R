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
      sliderInput("factor1", "Factor 1:", min = 0, max = 100, value = 50),
      sliderInput("factor2", "Factor 2:", min = 0, max = 100, value = 50),
      sliderInput("z", "Credibility Factor:", min = 0, max = 1, value = 0.5, step = 0.01),
      actionButton("calculateButton", "Calculate"),
      br(),
      helpText("Adjust the sliders for Factor 1, Factor 2, and the Credibility Factor, then click 'Calculate'.")
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
