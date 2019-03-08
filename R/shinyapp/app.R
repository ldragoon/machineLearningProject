# http://shiny.rstudio.com/tutorial/written-tutorial/lesson2/

library(shiny)

# Define UI -----
ui <- fluidPage(
  titlePanel("My Shiny App"),
  
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      img(src = "leaf-svgrepo-com.svg", height = 100, width = 100)
    )
  )
)

# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
shinyApp(ui = ui, server = server)