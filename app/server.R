# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
# http://shiny.rstudio.com
#
# library(shiny)
# library(caret)
# library(knnGarden)
library(plotly)
library(caret)
set.seed(1)
dataset.model = preProcess(model.training[,c(1:6)], method=c('nzv'))
dataset.norm = predict(dataset.model, model.training[,c(1:6)])
dataset.norm$Class<-ifelse(dataset.norm$Class=='yes', 1,0)
model.training$Class <- as.character(model.training$Class)
model.training$Class <- as.factor(model.training$Class)
modelrf = randomForest(Class ~ ., data=model.training, ntree = 1573, mtry = 2, importance=TRUE)

# Define server logic for random distribution application

shinyServer(function(input, output, session) {
  
output$image <- renderImage({
  list(src = "MoS2_Dataset_v2-1.png", 
       height = 400, width = 800)
}, deleteFile = FALSE)

output$MoS2_table = renderDT(data.training)
rv <- reactiveValues(filtered = TRUE)

output$pc <- renderParcoords({
dataframe.inputs = reactive({
  data.training[,input$Title]
  })

if(!is.null(input$Title)){
  for(title in input$Title){
    new = which(data.training$Title == title, arr.ind = TRUE)
    data1 = rbind(data1, data.training[new,c(1,5:13)])
  }
  names(data1) = col_labels
}
else{
  data1 = data.training[,c(5:13)]
  names(data1) = col_labels[2:10]
}

parcoords(data1, color = list(colorBy = input$group, colorScale = "scaleOrdinal", colorScheme = "schemeCategory10"),
      withD3 = TRUE, rownames = F, alphaOnBrushed = 0.15, brushMode = '1D-axes', autoresize = FALSE, reorderable = TRUE)

})

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


growth_map <- observeEvent(input$gr_map, {
  growth.data$S_T = input$gr_S_T
  growth.data$Highest_growth_T = input$gr_Highest_growth_T
  growth.data$Growth_Time = input$gr_Growth_Time
  growth.data$yes = predict(modelrf, growth.data, type='prob')[,2]
  
  output$plot1 = renderPlotly({
    p <- plot_ly(data = growth.data, x=~Mo_T,y=~Growth_P, z=~yes, type = "contour", colorscale='Jet')
    p <- p %>% layout(xaxis = list(title="Mo Precursor Temp ()"), yaxis = list(title="Growth Pressure (Torr)"))
    p <- p %>% colorbar(limits=c(0.5,1), title="Will Form?")
  })
  
}, ignoreInit = F, ignoreNULL = F)

# Show the values in an HTML table ----
output$concentrationvalues <- renderTable({
  sliderValues()
}, striped = T, width = '100%', bordered = T)


val <- reactive({
    data.frame(
      Mo_T = input$Mo_T,
      S_T = input$S_T,
      Highest_growth_T = input$Highest_growth_T,
      Growth_Time = input$Growth_Time,
      Growth_P = input$Growth_P,
      stringsAsFactors = F
    )
})

observeEvent(rv$filtered, {
  # create a proxy with which we will communicate between
  # Shiny and the parallel coordinates without a re-render
  pcp <- parcoordsProxy("pc")
  if(rv$filtered) {
    pcFilter(
      pcp
    )
  } else {
    pcFilter(pcp, list())
    
  }
  toggle('text_div')
})


outtable <- observeEvent(input$getprobs, {

for(method in input$updateconcentration){
Method = rbind(Method, method)
 if(method == "Random Forest"){
   Prediction = rbind(Prediction, c(signif(predict(modelrf, val(), type="prob")[2], digits=2)))
 }
else{
  Prediction = rbind(Prediction, (as.character(knnVCN(TrnX=model.training[,c(1:5)], 
                       TstX=val(), 
                       OrigTrnG=model.training[,c(6)],method='canberra', K=5, ShowObs = T)[,6])))
}}

output$valtable <- renderTable({data.frame(Method, Prediction)}, striped = T, width = '100%', bordered = T)
})  

})
