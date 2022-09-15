# Load libraries
# install.packages("librarian")
librarian::shelf(shiny)

# Define the UI
reactive_ui <- fluidPage(
  
  # Let's create the radio buttons
  numericInput(inputId = "my_input",
               label = "Type a number",
               value = 25),
  
  # And print the output
  "Square root is: ",
  textOutput(outputId = "my_output")
  
)  

# Define the server
reactive_server <- function(input, output){
  
  # Reactively receive the input and take the square root
  square_root <- reactive({
    sqrt(input$my_input)
  })
  
  # Now render that square root as an output
  output$my_output <- renderText( square_root() )
  
}

# Create the app
shinyApp(ui = reactive_ui, server = reactive_server)
