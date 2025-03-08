library(shiny)
library(stats)
library(ggplot2)

# Define UI
ui <- fluidPage(
  titlePanel("Maximum Likelihood Estimation (MLE) for Coin Toss"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("num_heads", "Number of Heads:", min = 0, max = 1000, value = 500),
      sliderInput("num_tosses", "Total Number of Tosses:", min = 1, max = 1000, value = 500),
      actionButton("calculateButton", "Calculate MLE"),
      br(),
      helpText("Adjust the sliders for the number of heads and total number of tosses, then click 'Calculate MLE'.")
    ),
    mainPanel(
      h4("Maximum Likelihood Estimate (MLE) of Probability of Heads:"),
      verbatimTextOutput("mleOutput"),
      plotOutput("lineChart")
    )
  )
)

# Define server
server <- function(input, output) {
  output$mleOutput <- renderPrint({
    # Calculate MLE using binomial distribution
    probability_heads <- input$num_heads / input$num_tosses
    likelihood <- dbinom(input$num_heads, size = input$num_tosses, prob = probability_heads)
    mle_estimate <- likelihood / choose(input$num_tosses, input$num_heads)
    
    # Display the MLE estimate
    paste("MLE of probability of heads:", round(mle_estimate, 4))
  })
  
  output$lineChart <- renderPlot({
    # Create a line chart to visualize the result
    probability_values <- seq(0, 1, length.out = 100)
    likelihood_values <- dbinom(input$num_heads, size = input$num_tosses, prob = probability_values)
    mle_line <- data.frame(Probability = probability_values, Likelihood = likelihood_values)
    
    ggplot(mle_line, aes(x = Probability, y = Likelihood)) +
      geom_line() +
      labs(title = "Likelihood Function",
           x = "Probability of Heads",
           y = "Likelihood") +
      theme_minimal()
  })
}

# Run the application
shinyApp(ui = ui, server = server)
