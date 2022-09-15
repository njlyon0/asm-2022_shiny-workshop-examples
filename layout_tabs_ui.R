## ------------------------------------- ##
         # Layout Options - Tabs
## ------------------------------------- ##
# Call needed libraries
library(shiny); library(htmltools); library(lterpalettefinder)

# User Interface (UI) --------------
tabs_ui <- fluidPage(

  # Add a title that appears in the browser tab
  title = "Shiny Tabs",

  # Title within app
  headerPanel(list(title = "Layout Options - Tabs",
                   htmltools::img(src = "lter_logo.png",
                                  height = 42,
                                  align = "right") ) ),

  # Decide on layout
  tabsetPanel(

    # UI - Tab 1 Content ----
    tabPanel(title = "Bins & Color",

      # Heading
      htmltools::h3("Decide on Number of Histogram Bins"),

      # Slider for deciding on number of historgram bins
      sliderInput(inputId = "bin_num",
                  label = "Number of bins:",
                  min = 5, value = 30, max = 50),

      # Heading
      htmltools::h3("Pick a Plot Color"),

      # Color dropdown menu
      selectInput(inputId = "color",
                  label = "Choose a Color",
                  choices = palette_find(site = "LTER"),
                  selected = palette_find(site = "LTER")[2])

    ), # Close `tabPanel(...`

      # UI - Tab 2 Content ----
    tabPanel(title = "Labels",

      # Heading
      htmltools::h3("Enter Plot Labels"),

      # X-axis label
      textInput(inputId = "x_lab", label = "X-Axis Label"),

      # Y-axis label
      textInput(inputId = "y_lab", label = "Y-Axis Label"),

      # Plot title
      textInput(inputId = "title", label = "Plot Title"),
    ), # Close `column(...`

    # UI - Tab 3 Content ----
    tabPanel(title = "Plot",
      plotOutput(outputId = "histo")
    ) # Close `column(...`
  ) # Close `fluidRow(...`
) # Close `fluidPage(...`

# Server ---------------------------
# To better demonstrate that layout is *only* a UI thing, all layout options will use the same script containing the server function
source("layout_server.R")

# Assemble App ---------------------
shinyApp(ui = tabs_ui, server = layout_server)

# End ----
