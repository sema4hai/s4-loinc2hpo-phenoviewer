#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

parse_termIdInput <- function(inputString) {
  flatten_chr(str_split(str_remove_all(inputString, ' '), ','))
}

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  termIdLongitudinal <- reactive({
    parse_termIdInput(inputString = input$termIdLongitudinal)
  })

  output$termIdLongitudinal <- renderText(
    str_c(termIdLongitudinal(), collapse = ",")
  )
  
  termIdRacialDifferences <- reactive({
    parse_termIdInput(inputString = input$termIdRacialDifferences)
  })
  
  output$termIdRacialDifferences <- renderText(
    str_c(termIdRacialDifferences(), collapse = ',')
  )
  
  ## Plot longitudinal changes of being tested for specified phenotype
  output$tableTestedLongitudinal <- renderDataTable({
    table_phenotype_been_tested_longitudinal(termIdLongitudinal())
  })
  
  output$plotTestedLongitudinal <- renderPlot({
    plot_phenotype_been_tested_longitudinal(termIdLongitudinal())
  })
  
  ## Plot longitudinal changes of being observed for specified phenotype
  output$tableObservedLongitudinal <- renderDataTable({
    table_phenotype_been_observed_longitudinal(termIdLongitudinal())
  })
  
  output$plotObservedLongitudinal <- renderPlot({
    plot_phenotype_been_observed_longitudinal(termIdLongitudinal())
  })
  
  ## Plot racial differences for being tested for specified phenotype
  output$tableTestedRacialDifference <- renderDataTable({
    table_phenotype_been_tested_racial_difference_by_phenotype(termIdRacialDifferences())
  })
  
  output$plotTestedRacialDifference <- renderPlot({
    plot_phenotype_been_tested_racial_difference_by_phenotype(termIdRacialDifferences())
  })
  
  ## Plot racial differences for being observed for specified phenotype
  output$tableObservedRacialDifference <- renderDataTable({
    table_phenotype_been_observed_racial_difference_by_phenotype(termids = termIdRacialDifferences())
  })
  
  output$plotObservedRacialDifference <- renderPlot({
    plot_phenotype_been_observed_racial_difference_by_phenotype(termids = termIdRacialDifferences())
  })

})
