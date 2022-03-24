#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  termIdLongitudinal <- reactive({
    input$termIdLongitudinal
  })

  output$termIdLongitudinal <- renderText(
    termIdLongitudinal()
  )
  
  termIdRacialDifferences <- reactive({
    input$termIdRacialDifferences
  })
  
  output$termIdRacialDifferences <- renderText(
    termIdRacialDifferences()
  )

  output$distPlot <- renderPlot({

      # generate bins based on input$bins from ui.R
      x    <- faithful[, 2]
      bins <- seq(min(x), max(x), length.out = input$bins + 1)

      # draw the histogram with the specified number of bins
      hist(x, breaks = bins, col = 'darkgray', border = 'white')

  })
  
  ## Plot longitudinal changes of being tested for specified phenotype
  output$plotTestedLongitudinal <- renderPlot({
    
  })
  
  ## Plot longitudinal changes of being observed for specified phenotype
  output$plotObservedLongitudinal <- renderPlot({
    
  })
  
  ## Plot racial differences for being tested for specified phenotype
  output$plotTestedRacialDifference <- renderPlot({
    
  })
  
  ## Plot racial differences for being observed for specified phenotype
  output$plotObservedRacialDifference <- renderPlot({
    
  })

})
