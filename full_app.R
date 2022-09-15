#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(sf)
library(lterdatasampler)
library(tidyverse)

##### Wrangling (Eventually, move to global.R)

watershed_polys <- sf::read_sf(here::here("data", "exwatershed1"), layer = "exwatershed1") %>% 
  st_transform(4326) %>% 
  arrange(WS_)

andrews_text <- read_csv(here::here("data", "andrews_text.csv"))

#####

# Define UI for application that draws a histogram
ui <- navbarPage(
      "Andrews Forest",
      tabPanel("Overview",
        fluidPage(
          titlePanel("Overview"),
          fluidRow(
            column(4,
                   img(src = "https://lternet.edu/wp-content/uploads/2022/03/Lookout_Creek_in_the_HJ_Andrews_Experimental_Forest_Willamette_National_Forest_23908499686-1.jpg",
                       width = "100%")
                   ),
            column(8,
                   fluidRow(
                     h2("About The Forest"),
                     p("The H.J. Andrews Experimental Forest (AND) LTER is located in the Cascade Range of Oregon, and consists of 6,400 ha of conifer forest, meadows, and stream ecosystems. This mountain landscape experiences episodic disturbances, including fires, floods, and landslides. The question central to AND LTER research is: How do climate, natural disturbance, and land use, as influenced by forest governance, interact with biodiversity, hydrology, and carbon and nutrient dynamics? Andrews LTER research illuminates the complexity of native, mountain ecosystems such as: forest stream interactions; roles of dead wood; and effects of forest harvest and disturbance on hydrology, vegetation, and biogeochemistry over multiple time scales. Andrews LTER research has also been central to informing regional and national forest policy. Future research will address ongoing change in streams, forests, climate, and governance."),
                     h2("About This Project"),
                     p("This project demonstrates how a site might use Shiny apps to communicate results from their research")),
                      
                  leafletOutput("andrews_map", width = "90%", height = 350))
          ),
        )
      )
        ,
        
      tabPanel("Watershed Characteristics",
               fluidPage(
                 titlePanel("Watershed Characteristics"),
                 fluidRow(
                   sidebarPanel(width = 6,
                                selectInput(inputId ="dropdown_watershed",
                                            label = "Select Watershed",
                                            choices = c(unique(watershed_polys$WS_)),
                                            ),
                                textOutput("watershed_text"),
                                ),
                   column(6,
                          leafletOutput("watershed_map"))
                 )
                 
               )),
      tabPanel("Species Weights",
               fluidPage(
                 titlePanel("Species Weights"),
                 fluidRow(
                   sidebarPanel(width = 4,
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
                   ),
                   column(6,
                          # Create histogram output
                          plotOutput(outputId = "hist_out")
                   )
                   )
                 )
               ),
      tabPanel("Channel abundance",
               fluidPage(
                 titlePanel("Channel abundance"),
                 fluidRow(
                   sidebarPanel(width = 4,
                                # Radio buttons for species
                                radioButtons(inputId = "species",
                                             label = "Species",
                                             # The `setdiff(...)` is just to remove NAs
                                             choices = setdiff(x = unique(and_vertebrates$species), y = NA)),
                                verbatimTextOutput(outputId = "channel_text")
                   ),
                   column(6,
                          # Create plot output
                          plotOutput(outputId = "channel_out")
                   )
                 )
               )),

)

# Define server logic required to draw a histogram
server <- function(input, output) {

    #___________
    # Overview Tab
    #-----------
  
    # Map with marker at forest
    output$andrews_map <- renderLeaflet({
        leaflet() %>% 
          addTiles() %>% 
          addCircleMarkers(lng = -122.1641168884823, lat = 44.2310583215366, label = "Andrews Forest") %>% 
        addPopups(lng = -122.1641168884823, lat = 44.2310583215366, popup = "<img src = 'https://andrewsforest.oregonstate.edu/sites/default/files/lter/images/logos/hja/newtlogo1.jpg', height = '30'> <b>Andrews Forest</b>", options = popupOptions(closeButton = FALSE)) %>%
        setView(-122.1641168884823, 44.2310583215366, zoom = 5)
      
    })
    
    #_________
    # Watershed Characteristics
    #---------
    
    # Map with all watersheds
    output$watershed_map <- renderLeaflet({
      leaflet() %>% 
        addTiles() %>% 
        addPolygons(data = watershed_polys$geometry,
                    color = "black",
                    fill = TRUE,
                    fillColor = "forestgreen",
                    weight = 2)
    })
    
    # Make a polygon that will highlight when selected
    
        # First make a reactive object that contains the target polygon:
      selection <- reactive({watershed_polys %>% 
         dplyr::filter(WS_ == input$dropdown_watershed)})
      
    # Observe event updates the map only when the selection is changed! Very useful
      observeEvent(input$dropdown_watershed, {
        
        # Leaflet proxy let's us change the map without completely remaking it
        # First, remove the old polygon
        leafletProxy("watershed_map") %>% 
          removeShape(layerId = "Selected")
        # Then, add the new selection
        leafletProxy("watershed_map") %>% 
                addPolygons(data = selection()$geometry,
                            fill = "yellow",
                            color = "yellow",
                            opacity = 100,
                            layerId = "Selected")
      })
    
    # Watershed text:
      # Let's make a df of some watershed text to display, starting with vectors
      
      display_text <- reactive({andrews_text %>% 
          filter(watershed == input$dropdown_watershed)})
      
      text_df <- data.frame()
    output$watershed_text <- renderText(display_text()$history)
    
    #--------------
    # Species Weights
    #--------------
    
    # Subset dataframe to selected species
    ## Must be done inside of "reactive consumer"
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
             " weight","\n", "Site: ", input$dropdown_site)
    })
    
    # Create a histogram of this content
    output$hist_out <- renderPlot({
      ## Uses the reactively-created weight
      hist(x = and_actual()$weight_g,
           ## And the reactively-created title!
           main = hist_title(),
           xlab = "Weight (g)")
    })
    
    
    ##-----------
    ## Channel Abundance
    ##-----------
    and_channel <- reactive({
      lterdatasampler::and_vertebrates %>% 
        filter(species == input$species) %>% 
        drop_na(unittype) %>% 
        count(unittype) %>% 
        mutate(unittype = fct_reorder(unittype, n))
    })
    
    output$channel_out <- renderPlot({
      ggplot(data =and_channel(), aes(y = unittype, x = n)) +
        geom_col() +
        theme_minimal() +
        labs(x = "Count", y = "Channel Type")
    })
    
    output$channel_text <- renderText({
      "C = Cascade\nP = Pool\nSC = Side Channel\nR = Rapid\nIP = Isolated Pools\nS = Step\nI = Riffle"
    })
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
