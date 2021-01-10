# LOADING SHINY APP 

ui <- fluidPage(
  navbarPage("Covid-19 Dashboard",
             tabPanel("World Map",
              sidebarLayout(
               sidebarPanel(
                 fluidRow(h4("Chart controls")),
                 hr(),
                 selectInput("indic_wmap", h5("Select indicator"), 
                             choices = indic_list, selected = "total_deaths_per_million")
               ),
               mainPanel(plotOutput("wmap"))
               ),
              fluidRow(h6(paste0("Last Updated: ", lastUpdate)), align = "right")
              ),
             
             tabPanel("Country Page",
              sidebarLayout(
                sidebarPanel(
                  fluidRow(h4("Chart controls")),
                  hr(),
                  selectizeInput("c_country", h5("Select Country"),
                              choices = countryList, selected = "Hungary")
                  ),
                mainPanel(
                  plotOutput("cpage"),
                  plotOutput("cpage_tests"))
                ),
              fluidRow(h6(paste0("Last Updated: ", lastUpdate)), align = "right")
              ),
             
             tabPanel("Compare Countries",
              sidebarLayout(
                sidebarPanel(
                  fluidRow(h4("Chart controls")),
                  hr(),
                  selectInput("indic_compare", h5("Select indicator"), 
                              choices = indic_list, selected = "total_deaths_per_million"),
                  selectizeInput("c_compare", h5("Select Country"),
                                 choices = countryList, selected = c("Hungary", "Austria", "Czechia"),
                                 multiple = TRUE)
                  ),
                mainPanel(plotOutput("ccompare"))
                ),
              fluidRow(h6(paste0("Last Updated: ", lastUpdate)), align = "right")
              ),
             
             tabPanel("Barcharts",
              sidebarLayout(
                sidebarPanel(
                  fluidRow(h4("Chart controls")),
                  hr(),
                  selectInput("indic_bar", h5("Select indicator"), 
                              choices = indic_list, selected = "total_deaths_per_million"),
                  sliderInput("slid_bar", h5("Countries displayed"),
                              min = 10, max = 50, value = 20)
                  ),
                mainPanel(plotOutput("bar"))
                ),
              fluidRow(h6(paste0("Last Updated: ", lastUpdate)), align = "right")
              ),
             navbarMenu("More",
              tabPanel("Help",
               fluidRow(h4("Coming soon!"))
              ),
              tabPanel("About",
               fluidRow(h5("Version: 0.5 beta")),
               fluidRow(h5("Data Source: Our World in Data"))
               ),
              tabPanel("Changelog",
               fluidRow(h4("v0.5 beta")),
               fluidRow(h5("Initial release: please note that not all functions may work properly."))
              )
              )
  ),
)




server <- function(input, output, session) {
  # worldmap
  output$wmap <- renderPlot({
    f_worldMapChart(indicator=input$indic_wmap)
  })
  
  # country page
  output$cpage <- renderPlot({
    f_basicChart(countryName=input$c_country)
  })
  output$cpage_tests <- renderPlot({
    f_testCountryChart(countryName=input$c_country)
  })
  
  # country compare
  output$ccompare <- renderPlot({
    f_compareChart(countryList=input$c_compare, indicator = input$indic_compare)
  })
  
  # barcharts
  output$bar <- renderPlot({
    f_barChart(indicator = input$indic_bar, countryNumber = input$slid_bar)
  })
  
}





