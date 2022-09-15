# Server ---------------------------
# Assemble server function
layout_server <- function(input, output){

  # Histogram assembly
  output$histo <- renderPlot({
    graphics::hist(x = sample(x = 1:1000,
                              size = 100,
                              replace = TRUE),
                   breaks = input$bin_num,
                   col = input$color,
                   xlab = input$x_lab,
                   ylab = input$y_lab,
                   main = input$title)
  })

} # Close `server{...`
