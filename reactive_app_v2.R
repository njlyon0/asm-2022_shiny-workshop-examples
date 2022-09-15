# Load libraries
# install.packages("librarian")
librarian::shelf(shiny, htmltools, tidyverse, leaflet, lter/lterdatasampler)

# Define UI
reactive_ui <- fluidPage(
  
  # Dropdown for watershed
  selectInput(inputId = "dropdown_site",
              label = "Site",
              # Choices are "All" or `sitecode` values in data
              choices = c("All", unique(and_vertebrates$sitecode))),
  
  # Radio buttons for species
  radioButtons(inputId = "button_spp",
               label = "Species",
               # The `setdiff(...)` is just to remove NAs
               choices = setdiff(x = unique(and_vertebrates$species), y = NA)),
  
  # Create histogram output
  plotOutput(outputId = "hist_out")
  
)

# Define server
reactive_server <- function(input, output){
  
  # Subset dataframe to selected species
  and_v2 <- reactive({
    lterdatasampler::and_vertebrates %>%
      dplyr::filter(species == input$button_spp)
  })
  
  # Subset dataframe to desired site
  ## Also done in reactive consumer
  and_actual <- reactive({
    ## If site is "All" don't subset
    if(input$dropdown_site == "All"){ 
      and_v2()
      ## Otherwise, subset to selected site
    } else { 
      and_v2() %>%
        dplyr::filter(sitecode == input$dropdown_site) }
  })
  
  # Assemble title from inputs to be more informative
  hist_title <- reactive({
    paste0("Histogram of ", tolower(input$button_spp),
           " weight", "\n", "Site: ", input$dropdown_site)
  })
  
  # Create a histogram of this content
  output$hist_out <- renderPlot({
    ## Uses the reactively-created weight
    hist(x = and_actual()$weight_g,
         ## And the reactively-created title!
         main = hist_title(),
         xlab = "Weight (g)")
  })
  
}

# Create app
shinyApp(ui = reactive_ui, server = reactive_server)

