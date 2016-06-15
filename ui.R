library(shiny)
#Vector of violation types in alphabetical order
catVec = c('Bicycle Violation','Drugs', 'DUI','Failure to Stop/Yield','Hit and Run','Inspection Violation', 'License','Litter','Speeding','Texting')

shinyUI(fluidPage(
  # Application title
  titlePanel("Moving Violations in Somerville, MA"),
  fluidRow(
    
    column(3,checkboxGroupInput("Days","Day of week: ",c("Sunday","Monday","Tuesday","Wednesday",
                                                         "Thursday","Friday","Saturday"),selected=c("Saturday","Sunday")),
           dateRangeInput("dRange", "Date Range", start = "2015-01-01", end = "2016-01-01", min = "2001-06-01", max = "2016-05-18", format = "yyyy-mm-dd", startview = "month", weekstart = 0, language = "en", separator = "to", width = NULL),
           sliderInput("tRange", "Time of Day", 0, 24, c(9,17),step=1,post=':00'),
           checkboxGroupInput("viol","Violation",choices=catVec,selected=c("Speeding","Texting"))
    ),
    column(9, 
  tabsetPanel(
    tabPanel("Introduction",
             tags$div(class="Intro", align="left",
                h3("Introduction"),
                p("This app was designed to enable exploration of traffic enforcement patterns in Somerville, MA in both time and space.
                  The dataset is publicly available", a(href="data.somervillema.gov","here"), ", and contains information
                  about over 70,000 vehicle citations around Somerville between 2010 and May 2016."),
                hr(),
                h3("Instructions"),
                p("The ''Map'' tab allows you to filter which data are displayed on the map."),
                p("The ''Table'' tab shows the raw counts of each charge along with the proportion of each in the given date range."),
                p("The ''Time Series'' tab allows the trends to be explored as a function of time instead of space."),
                h3("Happy Exploring!",align="center"),
                p("Feel free to e-mail questions or comments to matthew.applegate [at] tufts.edu",align="center")
                  )
    ),
    tabPanel("Map",plotOutput("citationPlot"),plotOutput("citationBar")),
    tabPanel("Table",br(),br(),dataTableOutput("tab")),
    tabPanel("Time Series",br(),plotOutput("timeSeries"),br(),plotOutput("timeHist"))
  ),
align="center")
)
)
)