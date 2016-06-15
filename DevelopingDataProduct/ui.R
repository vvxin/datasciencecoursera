library(shiny)
library(datasets)
library(markdown)

shinyUI(navbarPage("WEATHER and OZONE",
  
  # Show data table with DT package
  tabPanel("Data", DT::dataTableOutput('dataTable')),
  
  # Explore data with plot and lm line
  tabPanel("Plot",
    sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "xCol",
                    label = "Choose a varialbe to compare with Ozone",
                    choices = names(airquality)[c(2,3,4)]),
        
        checkboxInput(inputId = "askFitlm",
                      label = strong("Show linear fitted line"),
                      value = FALSE
          )
      ),
             
      mainPanel(
        plotOutput("ozonePlot")
      )
    )
  ),
  
  # Run model to predict Ozone with weather 
  tabPanel("Model",
   sidebarLayout(
      sidebarPanel(
        sliderInput(inputId = "trainPercent",
                    label = "Choose percentage of training dataset:",
                    min = 0.5, max = 0.9, value = 0.8, step = 0.05),
        
        selectInput(inputId = "method",
                    label = "Select a method:",
                    choices = c("Linear Regression" = "lm",
                                "Random Forest"     = "rf")),
        
        checkboxGroupInput(inputId = "var2train",
                           label = "Select variables as model input:",
                           choices = names(airquality)[c(2,3,4,5)],
                           selected = names(airquality)[3]),
        
        actionButton(inputId = "action",
                     label = "Run the model")
      ),
      
      mainPanel(
       
        h4("Correlation coefficient of test dataset and model predicted:"),
        verbatimTextOutput("modelResult"),
        plotOutput("testPlot")
      )
      
    )
    
  ),
  
  # Documentation of this application
  tabPanel("About",
    fluidRow(
      includeMarkdown("about.md")
    )
  )
  
))