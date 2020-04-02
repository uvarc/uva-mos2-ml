# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# http://shiny.rstudio.com
#
#library(shiny)
set.seed(1)
model1 = randomForest(Class ~ ., data=model.training, ntree = 1573, mtry = 2, importance=TRUE)
# Define server logic for random distribution application
shinyServer(function(input, output, session) {
output$MoS2_table = renderDT(data.training)

sliderValues <- reactive({
  data.frame(
    Name = c("Mo_T",
             "S_T",
             "Highest_growth_T",
             "Growth_Time",
             "Growth_P"),
    Value = as.character(c(input$Mo_T,
                           input$S_T,
                           input$Highest_growth_T,
                           input$Growth_Time,
                           input$Growth_P)),
    stringsAsFactors = FALSE)
  
})

# Show the values in an HTML table ----
output$concentrationvalues <- renderTable({
  sliderValues()
})

val <- eventReactive(
  input$updateconcentration, {
    data.frame(
      Mo_T = input$Mo_T,
      S_T = input$S_T,
      Highest_growth_T = input$Highest_growth_T,
      Growth_Time = input$Growth_Time,
      Growth_P = input$Growth_P,
      stringsAsFactors = F
    )}
)

output$concentrationvalues <- renderText({
  predict(model1, val(), type="prob")[2]
})

observeEvent(input$updateconcentration, {
  toggle('text_div')
  output$text = renderText({
      paste("      A probability value of less than 0.4 indicates difficulty in forming monolayers.
      A probability value of greater than 0.6 indicates confidence in forming monolayers. 
      A probability value between 0.4 and 0.6 indicates uncertainty in the model predictions.")
  })
})

#output$concentrationvalues <- renderText({
#  tags$h6("Probability value less than 0.4 indicates low confidence in forming monolayers.")
#  tags$h6("Probability value greater than 0.6 indicates high confidence in forming monolayers.")
#  tags$h6("Probability value between 0.4 and 0.6 indicates uncertainty in the model predictions.")
#  })

})