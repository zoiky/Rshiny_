#clear working directory
rm(list=ls()) 

#setting working directory
setwd("D:/R") 
library(shiny)
library(ggplot2)

#to help with the filter funtion for inputs
library(dplyr)  

#loading dataset

testdata <- read.csv("prism2dataset.csv", stringsAsFactors = FALSE)
#testdata$malaria <- as.numeric(testdata$malaria)

#checking data has been loaded
#print(str(testdata))

# building the ui.
ui <- fluidPage(
  
  # App title ----
  titlePanel("Malaria test positivity rate measurement"),
  
  
  sidebarLayout(
    
    sidebarPanel(
      
      # Input: Select the random distribution type ----
      radioButtons("gender", "Gender ppt",
                   choices = c("Male", "Female"),
                   selected = "Female"), 
      
      br(),
      
      # user Inputs: gender, malaria ----
      sliderInput("malaria","Malaria value",
                  value = 1,
                  min = 1,
                  max = 9)
      
    ),
    
    mainPanel(
      plotOutput("plot")
      
    )
  )
)

server <- function(input, output) {

  
  filtered <- reactive({
    testdata %>%
      filter(malaria >= input$malaria[1], 
             gender == input$gender
      )
    

    
  })
  
  
  output$plot <- renderPlot({

    ggplot(filtered(), aes(x = ageyrs)) +
      geom_histogram()
    
 #debug. Prints values of inputs. 
 # observe ({print(input$malaria)})
  })
}

shinyApp(ui, server)


