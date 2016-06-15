library(shiny)
library(datasets)
library(caret)
library(randomForest)
library(DT)

shinyServer(function(input, output) {
  
  output$dataTable <- DT::renderDataTable(
    DT::datatable(airquality, options = list(searching = FALSE))
  )
  
  selectedData <- reactive({
    airquality[, c("Ozone", input$xCol)]
  })
  
  output$ozonePlot <- renderPlot({
    fit_lm <- lm(selectedData()[,2] ~ selectedData()[,1])
    
    plot(selectedData(), pch = 3)
    
    if (input$askFitlm) {
      abline(fit_lm, col = "red")
    }
  })
  
  modelData <- reactive({
    airquality[, c("Ozone", input$var2train)]
  })
  
  observeEvent(input$action, {
    output$modelResult <- renderPrint({
      
      input$action
      set.seed(12345)
      
      data <- modelData()
      data <- na.omit(data)
      trainSub <- createDataPartition(data$Ozone, 
                                      p = input$trainPercent,
                                      list = F)
      train <- data[trainSub,]
      test  <- data[-trainSub,]
      fit   <- train(Ozone ~ .,
                     data = train,
                     method = input$method,
                     trControl = trainControl(method = "cv", number = 4))
      predicted <- predict(fit, test)
      
      
      cor(test$Ozone, predicted)
    })
  })
  
  observeEvent(input$action, {
    output$testPlot <- renderPlot({
      
      input$action
      set.seed(12345)
      
      data <- modelData()
      data <- na.omit(data)
      trainSub <- createDataPartition(data$Ozone, 
                                      p = input$trainPercent,
                                      list = F)
      train <- data[trainSub,]
      test  <- data[-trainSub,]
      fit   <- train(Ozone ~ .,
                     data = train,
                     method = input$method,
                     trControl = trainControl(method = "cv", number = 4))
      predicted <- predict(fit, test)
      plot(predicted, test$Ozone,
           xlim = c(0,120), ylim = c(0,120),
           main = "Test dataset vs. Predicted result")
    })
  })
  
  
})