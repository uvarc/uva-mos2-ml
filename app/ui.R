# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
#setwd("/home/prasanna/Dropbox/GIT_RSHINY/UVA_MoS2_CVD/uva-mos2-ml/app/")

source("data.R")
source("libraries.R")
library(shiny)

titles = c('All', unique(data.training[,1]))

shinyUI(fluidPage(useShinyjs(), #theme="bootstrap.css",
 # title = "Materials Informatics", h1(HTML(paste0("Hello O",tags$sub("2"))))
  titlePanel(column(12,tags$h3("Data-Driven Assessment of CVD Grown MoS2 
                               Thin Films"))), br() ,
mainPanel(
tabsetPanel(type = "tabs",
tabPanel("Home",
fluidRow(
column(10, tags$h3("Goal"), "Predicting whether a given set of CVD parameters
       will give rise to MoS2 monolayers",
tags$h3("Demo Website"), "We will use this web portal to showcase some of 
our machine learning capabilities in advancing Transition Metal Dichalcogenide growth (shown below)." 
,imageOutput('image')
),
tags$br(),
tags$br()
#column(6, tabsetPanel(type = "tabs", 
),
fluidRow(
column(12, tags$h4("Thank you for visiting our site. 
                   We will continue to update.")),
column(12, tags$h4("Contact Us"), "If there are questions, send an email to Prasanna V. Balachandran (pvb5e at virginia dot edu). Updates to this website were in part due to P. Delsa"),
#column(12, tags$br(), "Updates to this website were in part due to P. Delsa")
)
),
tabPanel("CVD Grown MoS2 (Demo)",
tabsetPanel(type = "tabs",
tabPanel("Dataset",
fluidRow(
column(10,
tags$br(),
tags$h4("The dataset used in the MoS2 machine learning work"),
tags$h4("The training dataset is shown below"),
DTOutput(outputId = "MoS2_table")
))
),

#Main panel shows predictions from Random Forest, k-NN, and SVM, depending on which methods are chosen
tabPanel("Predictions",
fluidRow(
column(12, 
tags$br(),
tags$h3("Please select the CVD growth parameters to predict the formation of 
        MoS2 monolayers from the machine learning model."),
tags$br(),
sidebarLayout(
sidebarPanel(
sliderInput(inputId = "Mo_T", label = "Mo Precursor Temperature", 
            value = 300, min = 300, max = 850),
sliderInput(inputId = "S_T", label = "S Precursor Temperature",
            value = 100, min = 100, max = 325),
sliderInput(inputId = "Highest_growth_T", label = "Highest Growth Temperature", 
            value = 530, min = 530, max = 880),
sliderInput(inputId = "Growth_Time", label = "Growth Time", 
            value = 3, min = 3, max = 240),
sliderInput(inputId = "Growth_P", label = "Growth Pressure", 
            value = 0.02, min = 0.02, max = 760)
),
mainPanel(
checkboxGroupInput('updateconcentration', 'Select machine learning method(s)', choices = c("Random Forest", "k-NN", "SVM"), inline = T),
tags$h5("After having chosen a CVD growth condition and machine learning method(s), please hit the button below. "),
actionButton(inputId = "getprobs", label = "Predict MoS2 Monolayer Formation Probability"),
tags$br(),
tags$br(),
tags$h5("For the Random Forest model, a probability value of:"),
tags$ul(tags$li('> 0.6 indicates confidence in forming monolayers'), 
        tags$li('Between 0.4 and 0.6 indicates uncertainty'),
        tags$li('< 0.4 indicates difficulty in forming monolayers')
),
tags$br(),
tags$h5("The probability of forming MoS2 Monolayer based on the predictions from ML methods(s) is given below:"),
fluidRow(
column(4, tableOutput("concentrationvalues")),
tags$br(),
column(4, tableOutput("valtable"), offset = 2)
))
)
)
)),

#Main panel shows parallel coordinate plots, grouped by selected value or shows papers selected
tabPanel("Parallel Plots",
tabsetPanel(type="tabs",
tabPanel("Plots",
tags$h3("Parallel Coordinate Plots"),
sidebarLayout(
sidebarPanel(
tags$h5("For all compounds, CVD type is double vapor, Mo precursor is MoO3 powder, and S substrate is S powder"),
tags$br(),
radioButtons('group', 'Group by: ', selected="Will Form?", choiceName = c(options), choiceValues = c(col_labels)),
tags$br(),
tags$h5("NOTE: The Title selection is meant to be used when multiple titles are selected, not 'All'"),
tagList(
 tags$h3("Select by Title: "),
 selectizeInput('Title', label = NULL, unique(data.training[,1]), selected = NULL, multiple = TRUE, width = '100%')
)
),
mainPanel(
tagList(
 parcoordsOutput("pc", width = '100%', height = '500px')
)
))
),
tabPanel("Help", includeMarkdown("ParcoordsReadMe.Rmd"))
)
),
#Main panel shows growth maps of data based on predictions from Random Forest and SVM model
tabPanel("Growth Maps",
fluidRow(
tags$br(),
tags$h3("Please select CVD growth parameters for growth map"),
tags$br(),
sidebarLayout(
sidebarPanel(
tags$h5("Growth map based on predictions from random forest model"),
tags$br(),
sliderInput(inputId = "gr_S_T", label = "S Precursor Temperature",
           value = 145, min = 100, max = 250),
sliderInput(inputId = "gr_Highest_growth_T", label = "Highest Growth Temperature",
           value = 730, min = 530, max = 880),
sliderInput(inputId = "gr_Growth_Time", label = "Growth Time",
           value = 52, min = 3, max = 240),
actionButton("gr_map", "Adjust Growth Map")
),
mainPanel(
tagList(
 plotlyOutput("plot.rf"),
 tags$br(),
 plotlyOutput("plot.svm")
)
)))),

tabPanel("Background Information", includeMarkdown("BackgroundInfo.Rmd")) 

)
)

)
)))
