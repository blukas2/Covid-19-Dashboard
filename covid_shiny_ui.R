ui <- fluidPage(
  navbarPage("Covid-19 Dashboard",
             tabPanel("World Map",
                      sidebarLayout(
                        sidebarPanel(
                          fluidRow(h4("Chart controls")),
                          hr(),
                          selectInput("continent_wmap", h5("Select region"), 
                                      choices = continentList, selected = "World"),
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
                                         choices = countryList, selected = "Hungary"),
                          dateRangeInput("date_cpage", h5("Date range"),
                                         start = "2020-03-01",
                                         end = lastUpdate,
                                         min = "2020-01-01",
                                         max = lastUpdate)
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
                                         multiple = TRUE),
                          dateRangeInput("date_compare", h5("Date range"),
                                         start = "2020-03-01",
                                         end = lastUpdate,
                                         min = "2020-01-01",
                                         max = lastUpdate)
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
                          selectInput("continent_bar", h5("Select region"), 
                                      choices = continentList, selected = "World"),
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
                                 fluidRow(h5("Version: 1.0")),
                                 fluidRow(h5("Data Source: Our World in Data"))
                        ),
                        tabPanel("Changelog",
                                 fluidRow(h4("v1.0")),
                                 fluidRow(h5("Option to select date ranges added.")),
                                 fluidRow(h5("Error messages when changing selection removed.")),
                                 fluidRow(h4("v0.7 beta")),
                                 fluidRow(h5("Regions can be selected on the world map.")),
                                 fluidRow(h5("Regions can be selected on the bar chart.")),       
                                 fluidRow(h4("v0.5 beta")),
                                 fluidRow(h5("Initial release: please note that not all functions may work properly."))
                        )
             )
  ),
)