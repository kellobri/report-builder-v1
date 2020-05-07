library(shiny)
library(shinythemes)
library(RColorBrewer)

sample <- readRDS("sample-data.RDS")

ui <- navbarPage("Report Design Builder", theme = shinytheme("sandstone"),
    
    tabPanel("1. Customize Visualization",
        sidebarLayout(
            sidebarPanel(
                radioButtons("colr", "Monitoring Phases:",
                             c("P-06.2017" = "Blues",
                               "P-06.2018" = "RdYlBu",
                               "P-10.2018" = "BuGn",
                               "P-10.2019" = "Spectral")),
                hr(),
                checkboxInput("reorder", label = "Dendogram Reordering", value = TRUE),
                checkboxInput("include", label = "Generalized Classes", value = TRUE),
                
                hr(),
                sliderInput("slider2", label = "Filter Range", min = 0, 
                            max = 100, value = c(40, 60))
            ),
            
            mainPanel(
                plotOutput("plot", width = "100%")
            )
        )
    ),
    
    tabPanel("2. Upload Datasets"),
    
    tabPanel("3. Export Report")
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$plot <- renderPlot({
        colorPal <- colorRampPalette(brewer.pal(8, input$colr))(25)
        scaled <- as.matrix(scale(sample))
        heatmap(scaled,
                col = colorPal,
                Colv=input$reorder, scale="none")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
