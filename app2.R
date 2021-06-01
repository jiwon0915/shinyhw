library(shiny)
library(data.table)
library(leaflet)

long_dat<-read.csv("C:/Users/kms60/OneDrive/shiny/long_dat.csv")

pal<-colorFactor("viridis", long_dat$type)

ui <- fluidPage(
  titlePanel("따릉이 최빈 노선"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("따릉이 최빈 노선 정보"),
      
      selectInput("rank",
                  label = "순위 선택",
                  choices = c("1", "2", 
                              "3", "4",
                              "5", "6",
                              "7", "8",
                              "9",'10'),
                  selected = "1"),
      
      
    ),
    mainPanel(leafletOutput("map"))
  )
)


server <- function(input, output,session){  
  
  rankInput <- reactive({
    long_dat[long_dat$순위==input$rank,]
  })
  
  output$map <- renderLeaflet({
      leaflet() %>% 
      setView(lng = 126.9784, lat = 37.566, zoom=11) %>% 
      addProviderTiles('CartoDB.Positron') %>% 
      addPolylines(dat=rankInput(), lng = ~lat,
                   lat=~lon, group=~rank,
                   color = "gray") %>% 
      addCircles(data = rankInput(), lng = ~lat,
                 lat=~lon, color = ~pal(type), 
                 radius =200) %>% 
      addLegend("topright", colors = c("#440154FF","#FDE725FF"),labels = c("대여","반납"))
    
  })
  
}

shinyApp(ui,server)
