#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)

mySideBar <- function(inputId) {
  sidebarPanel(
    textInput(inputId = inputId, label = "HPO TermId")
  )
}

# Define UI for application that draws a histogram
shinyUI(navbarPage(
  "MSDW Lab Phenotype Viewer",
  tabPanel("Longitudinal", 
           mySideBar(inputId = "termIdLongitudinal"),
           mainPanel(h2("Specified HPO TermId"),
                     textOutput(outputId = "termIdLongitudinal"))), 
  
  tabPanel("Racial Differences", 
           mySideBar(inputId = "termIdRacialDifferences"), 
           mainPanel(
             tabsetPanel(
               tabPanel("Plot",
                        h2("Racial Differences specified HPO TermId"),
                        textOutput(outputId = "termIdRacialDifferences")
                        ),
               tabPanel("Table",
                        h2("Show underlying data"))
             )
           )
           ),
  
  tabPanel("Help",
           sidebarPanel("Content"),
           mainPanel(h2("Hello")))
  )
)
