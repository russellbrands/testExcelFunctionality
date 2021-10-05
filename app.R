library(dplyr)
library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(rpivotTable)
library(DT)
library(excelR)

# Define UI for application that draws a histogram
header <- dashboardHeader(title="Dashboard")

sidebar <- dashboardSidebar(
    sidebarMenu(id = 'tabs',
                menuItem(text = 'Upload', tabName = "menuUpload", icon = icon("jedi")),
                menuItem(text = 'Excel',  tabName = "menuExcel",  icon = icon("dove"))
    )
)

body <- dashboardBody(
    tabItems(
        tabItem(tabName = 'menuUpload',
                box(width = 12,
                    fileInput('file1', 'Choose CSV File',
                              accept=c('text/csv', 'text/comma-separated- values,text/plain', '.csv')),
                    checkboxInput('header', 'Header', TRUE),
                    radioButtons('sep', 'Separator',
                                 c(Comma=',',
                                   Semicolon=';',
                                   Tab='\t'),
                                 'Comma')
                ),
                box(width = 12,
                    tabsetPanel(
                        id = "selected_data",
                        type = "pills",
                        tabPanel("tab-table", dataTableOutput(outputId = 'myTable') %>% withSpinner(type = 1, size = 1, color = '#0dc5c1') ),
                        tabPanel("tab-pivot", rpivotTableOutput(outputId = "myPivot") %>% withSpinner(type = 1, size = 1, color = '#0dc5c1') )
                    )
                )
        ),
        tabItem(
            tabName = 'menuExcel',
            box(width = 12,
                excelOutput(outputId = "myExcel") %>% withSpinner(type = 1, size = 1, color = '#0dc5c1')
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    mydata <- reactive({

        inFile <- input$file1

        if (is.null(inFile))
            return(NULL)

        tbl <- read.csv(inFile$datapath, header=input$header, sep=input$sep)

        return(tbl)
    })

    observeEvent(input$sendtopivot,
                 {
                     dta <- mydata
                 })

    output$myTable <- renderDataTable({mydata()})
    output$myPivot <- renderRpivotTable({rpivotTable(data = mydata())})
    output$myExcel <- renderExcel({excelTable(mydata(), allowComments = TRUE)})

}

# Run the application
shinyApp(
    ui = dashboardPage(header, sidebar, body),
    server = server# ,
    # session = session
)
