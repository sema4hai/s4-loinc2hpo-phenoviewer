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
library(shinyWidgets)


mySideBar <- function(multiInputId, defaultSelections, choices = hp_term_list$termid, ...) {
  sidebarPanel(
    multiInput(inputId = multiInputId, label = "Choose term(s)", 
               #choices = choices,
               #choiceNames = str_c(hp_term_list$termid, hp_term_list$label, sep = " "),
               choiceNames = hp_term_list %>% filter(termid %in% choices) %>% mutate(display = str_c(termid, label, sep = " ")) %>% pull(display),
               choiceValues = hp_term_list %>% filter(termid %in% choices) %>% pull(termid),
               selected = defaultSelections,
               options = list(
                 enable_search = TRUE,
                 non_selected_header = "Choose between\n(click to select):",
                 selected_header = "You have selected\n(click to unselect):"
               ))
  )
}

# Define UI for application that draws a histogram
shinyUI(navbarPage(
  "MSDW Lab Phenotype Viewer",
  tabPanel("Longitudinal", 
           mySideBar(multiInputId = "multiInputLongitudinal",
                     defaultSelections = c("HP:0000119", "HP:0000707", "HP:0000818", "HP:0001197", "HP:0001626"),
                     choices = intersect(hp_term_list$termid, unique(tested_phenotype_rank_all_by_year$termid))),
           mainPanel(
             tabsetPanel(
               tabPanel("Plot",
                        #h2("Specified HPO TermId"),
                        #textOutput(outputId = "termIdLongitudinal"),
                        h4("Longitudinal changes for phenotype being tested"),
                        plotOutput(outputId = "plotTestedLongitudinal"),
                        h4("Longitudinal changes for phenotype being observed"),
                        plotOutput(outputId = "plotObservedLongitudinal")),
               tabPanel("Table",
                        h4("Longitudinal changes for phenotype being tested"),
                        DT::dataTableOutput(outputId = "tableTestedLongitudinal"),
                        h4("Longitudinal changes for phenotype being observed"),
                        DT::dataTableOutput(outputId = "tableObservedLongitudinal"))))),
           
  
  tabPanel("Racial Differences", 
           mySideBar(multiInputId = "multiInputRacialDifferences",
                     defaultSelections = c('HP:0001901', 'HP:0500267', 'HP:0000118'),
                     choices = intersect(hp_term_list$termid, unique(racial_tested_abnormality_fisher$termid))), 
           mainPanel(
             tabsetPanel(
               tabPanel("Plot",
                        #h2("Racial Differences specified HPO TermId"),
                        #textOutput(outputId = "termIdRacialDifferences"),
                        h4("Racial differences for phenotype being tested"),
                        plotOutput(outputId = "plotTestedRacialDifference", height = "100%"),
                        h4("Racial difference for phenotype being observed"),
                        plotOutput(outputId = "plotObservedRacialDifference", height = "100%")),
               tabPanel("Table",
                        h4("Racial differences for phenotype being tested"),
                        DT::dataTableOutput(outputId = "tableTestedRacialDifference"),
                        h4("Racial difference for phenotype being observed"),
                        DT::dataTableOutput(outputId = "tableObservedRacialDifference"))))),
  
  tabPanel("Help",
           sidebarPanel("Tutorial"),
           mainPanel(h4("What is the app"),
                     p("This is a visualization tool to show the phenotypic 
                       diversity that are algorithmically transformed from clinical 
                       lab tests within the Mount Sinai Data Warehouse. "),
                     br(),
                     br(),
                     h4("How to use"),
                     p("The App contains two major parts, longitudinal changes 
                       for a phenotype being tested and observed and racial differences 
                       for a phenotype being tested and observed."),
                     br(),
                     br(),
                     h4("Authors"),
                     p("Biopharmar Research, Sema4"),
                     p("TODO: add more authors"),
                     br(),
                     br(),
                     h4("License"),
                     p("Copyright (c) 2022 Sema4"),
                     p("TODO: ask Sema4 legal and add Sema4 clauses"),
                     p("THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
                 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
                 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
                 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
                 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
                 SOFTWARE."),
                     br(),
                     br(),
                     h4("Reference and Citation"),
                     p("The App has an accompany manuscript, which includes technical details."),
                     p("TODO: add link for manuscript"),
                     br(),
                     br(),
                     h4("Contact"),
                     p("For all questions, contact aaron.zhang@sema4.com or xiaoyan.wang@sema4.com")))
  )
)
