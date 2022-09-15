# Load libraries
# install.packages("librarian")
librarian::shelf(shiny, htmltools, tidyverse, leaflet, lter/lterdatasampler)

# Define UI
overview_ui <- navbarPage(
  "Andrews Forest",
  tabPanel("Overview",
           fluidPage(
             titlePanel("Overview"),
             
             # This is the section we're focused on:
             fluidRow(
               column(4,
                      # Add image
                      img(src = "https://lternet.edu/wp-content/uploads/2022/03/Lookout_Creek_in_the_HJ_Andrews_Experimental_Forest_Willamette_National_Forest_23908499686-1.jpg",
                          width = "100%")
               ) # Close column
               ,
               column(8,
                      # Add some text within a row — this sets us up to add a map below the text
                      fluidRow(
                        h2("About The Forest"),
                        p("The H.J. Andrews Experimental Forest (AND) LTER is located in the Cascade Range of Oregon, and consists of 6,400 ha of conifer forest, meadows, and stream ecosystems. This mountain landscape experiences episodic disturbances, including fires, floods, and landslides. The question central to AND LTER research is: How do climate, natural disturbance, and land use, as influenced by forest governance, interact with biodiversity, hydrology, and carbon and nutrient dynamics? Andrews LTER research illuminates the complexity of native, mountain ecosystems such as: forest stream interactions; roles of dead wood; and effects of forest harvest and disturbance on hydrology, vegetation, and biogeochemistry over multiple time scales. Andrews LTER research has also been central to informing regional and national forest policy. Future research will address ongoing change in streams, forests, climate, and governance."),
                        h2("About This Project"),
                        p("This project demonstrates how a site might use Shiny apps to communicate results from their research")
                      ), # Close row
                      
                      # And add a placeholder output where we want our map to go
                      leafletOutput("andrews_map", width = "90%", height = 350
                      )
               ) # Close column
             )# Close fluidRow
           ), # Close fluidPage
  ), # Close Overview
  
  tabPanel("Species weights")
) # close navbarPage

# Define server logic required to draw a histogram
overview_server <- function(input, output) {
  
  # Map with marker at forest
  output$andrews_map <- renderLeaflet({
    leaflet() %>% 
      addTiles() %>% 
      addCircleMarkers(lng = -122.1641168884823, lat = 44.2310583215366, label = "Andrews Forest") %>% 
      addPopups(lng = -122.1641168884823, lat = 44.2310583215366, popup = "<img src = 'https://andrewsforest.oregonstate.edu/sites/default/files/lter/images/logos/hja/newtlogo1.jpg', height = '30'> <b>Andrews Forest</b>", options = popupOptions(closeButton = FALSE)) %>%
      setView(-122.1641168884823, 44.2310583215366, zoom = 5)
    
  })
}

# Create app
shinyApp(ui = overview_ui, server = overview_server)

