# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
#setwd("/Users/balachandran/RESEARCH/LANL/WEBSITE/ver_xdz/")

source("data.R")
source("libraries.R")

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
our machine learning capabilities in advancing Transition Metal Dichalcogenide growth (shown below).", 
tags$img(height = 400, width = 800, src = "MoS2_Dataset_v2-1.png")
),
tags$br(),
tags$br(),
#column(6, tabsetPanel(type = "tabs", 
                      ),
fluidRow(
#   column(4, tags$h4("Acknowledgments"), tags$img(height = 50, width = 50, 
#  src = "wordcloud.jpeg")),
column(12, tags$h4("Thank you for visiting our site. 
                   We will continue to update.")),
   column(12, tags$h4("Contact Us"), "If there are questions, send an email to Prasanna V. Balachandran (pvb5e at virginia dot edu)")
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
#dataTableOutput("MoS2_table")
DTOutput(outputId = "MoS2_table")
))
),
tabPanel("Predictions",
fluidRow(
column(12, 
tags$br(),
tags$h3("Please select the CVD growth parameters to predict the formation of 
        MoS2 monolayers from the machine learning model."),
tags$br(),
#sidebarPanel(
sliderInput(inputId = "Mo_T", label = "Mo Precursor Temperature", 
            value = 300, min = 300, max = 850),
sliderInput(inputId = "S_T", label = "S Precursor Temperature",
            value = 100, min = 100, max = 250),
sliderInput(inputId = "Highest_growth_T", label = "Highest Growth Temperature", 
            value = 530, min = 530, max = 880),
sliderInput(inputId = "Growth_Time", label = "Growth Time", 
            value = 3, min = 3, max = 240),
sliderInput(inputId = "Growth_P", label = "Growth Pressure", 
            value = 0.02, min = 0.02, max = 760),
tags$br(),
tags$h5("After having chosen a CVD growth condition, please hit the button below. "),
actionButton(inputId = "updateconcentration", label = "Predict MoS2 Monolayer Formation Probability"),
tags$h5("The probability of forming MoS2 Monolayer based on the predictions from trained Random Forests model is given below:"),
hidden(
  div(id='text_div',
      verbatimTextOutput("text")
  )
)
)
)
)),
mainPanel(tableOutput("concentrationvalues")
),
tabPanel("Help")
    )
))
))
#tags$h6("Probability value less than 0.4 indicates low confidence in forming monolayers.")
#tags$h6("Probability value greater than 0.6 indicates high confidence in forming monolayers.")
#tags$h6("Probability value between 0.4 and 0.6 indicates uncertainty in the model predictions.")