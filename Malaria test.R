# allows the user to select gender and malaria status looking over age. 
# Some issues with getting the slider inputs to work. 
# 1) making sure input is numeric rather than character
# 2) changing empty cells to "NA".

# 1) adding a slider for malaria, 
# 2) changing the x-axis to the date, 
# 3) changing the data graphed to be the estimated positivity rate 
# no. of malaria positive tests/total # tested for malaria). 
  
rm(list=ls()) 
setwd("D:/R/october2019") 
library(shiny)
library(readstata13)
library(dplyr)
library(ggplot2)

d <- read.dta13('/R/october2019/PRISM 2 expanded database FINAL.dta', nonint.factors = T) # read in data into a dataframe named 'd'
d <- d[,c('cohortid','date','ageyrs','visittype','gender','febrile','parasitedensity', 'malaria')] # narrowing down to just variables needed

#defining malaria as a binary true/false
d$malaria1 <- d$parasitedensity>0 & d$febrile=='febrile'  
d$malaria1 <- !is.na(d$malaria1)
d$malaria1 <- as.numeric(d$malaria1)
#print(d$malaria1)

#making a small dataframe with observations having malaria.
#malaria <- malaria %>% filter(d$malaria)
#sapply(d$malaria, function(x) {d$malaria <- as.numeric(malaria)})

# building the shiny ui.
ui <- fluidPage(
  
  titlePanel("Test positivity rate measurement"),
    sidebarLayout(
      sidebarPanel(
        # Input: Select the random distribution type ----
      radioButtons("malaria1", "Malaria check",
                   choices = c("1", "0"),
                   selected = "0"), 
      
      br(),
      sliderInput("ageyrs","Select Age",
                  value = 1,
                  min = 1,
                  max = 100)
      
    ),
    
    mainPanel(
      plotOutput("plotresults")
    )
  )
)

server <- function(input, output) {
  
  
  filtered <- reactive({
    d %>%
      filter(ageyrs == input$ageyrs, 
             malaria1 == input$malaria1
      )
  })

  output$plotresults <- renderPlot({
    
    ggplot(filtered(), aes(x = date)) +
    geom_histogram()
   #geom_bar()
    
  # for debugging, print to know what value the reactive varaible holds
  #  print(input$ageyrs)
  #  observe({ print(input$malaria1) })
  })
}

shinyApp(ui, server)

