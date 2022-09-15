# Load libraries
# install.packages("librarian")
librarian::shelf(shiny)

# Define UI
basic_ui <- fluidPage(
  titlePanel("A simple app"),
  "Here's some text",
  img(src = "https://lternet.edu/wp-content/themes/ndic/library/images/logo.svg")
)

# Define server
basic_server <- function(input, output){ }

# Create the app
shinyApp(ui = basic_ui, server = basic_server)
