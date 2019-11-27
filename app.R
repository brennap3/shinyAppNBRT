#
# This is a Shinydashboard web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building dashboard applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# install packages
##install.packages("plotly")
##install.packages("shinydashboard")

library(shiny)
library(datasets)
library(ggplot2)
library(plotly)
library(shinydashboard)

# Define UI for application that draws a histogram

ui <- dashboardPage(
  dashboardHeader(title="Mtcars Dashboard"),
  dashboardSidebar(
    sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Summary", tabName = "summary", icon = icon("th"))
      )
    ),
  dashboardBody(# Boxes need to be put in a row (or column)
    tabItems(
        tabItem(tabName = "dashboard",
          fluidRow(
              box(plotlyOutput("distPlot"), height = 250),
      
              box(
                title = "Controls",
                varSelectInput("variable", "Variable X:", mtcars),
                varSelectInput("variable2", "Variable Y:", mtcars),
                radioButtons("line", "Line type:",
                     c("Include line" = 1,
                       "Dont include line" = 2))
            )
          )
         ),
        tabItem(tabName = "summary",
                h2("Summary tab content, how i built the app"),
                
                h4("This is a simple app built in shiny and plotly.
                            The app was built with  a sidebar panel with a column selection input for the x and y axis, and
                            a main panel containing the reactive plot and a second tab containing 
                            the detail of how the app was built.
                            The plots are built using ggplot2, cast as a plotly object using ggplotly and displayed.
                            The total build time for the exercise was about 30 minutes.
                           "),
                h4("The app was written originally as a shiny app and then converted to a shinydashboard. The code for the app is show below:"),        
                h4("The radio buttons are used to choose which plotly plot object to display and the select inputs are used to choose which variable to display in the plotly plot."),
                h4("Menu Items are used to select the different tabs, dashboard with the plot and related controls. Summary app with the details of the app"),
                tags$a("link to shiny app on git",href="https://github.com/brennap3/shinyAppNBRT/blob/master/app.R")   
                )
                                
      )
    )
)

server <- function(input, output) {
  
  output$distPlot <- renderPlotly({
    ##create gg object with lines
    ggPlot1<-
      ggplot(
        mtcars, aes(x=!!input$variable,y=!!input$variable2,text=rownames(mtcars),group = 1)) +
      geom_point() + geom_line()
    ##create object without lines
    ggPlot2<-
      ggplot(
        mtcars, aes(x=!!input$variable,y=!!input$variable2,text=rownames(mtcars))) +
      geom_point() 
    
    ##create plotly object from ggplot object with the lines
    plotyGG<-ggplotly(ggPlot1)
    ##Create the the plotly object without the lines
    plotyGG2<-ggplotly(ggPlot2)
    
    #display plotly object choice baased on radio button
    print(
      if(input$line==1){plotyGG}
        else if(input$line==2){plotyGG2}
        else{plotyGG}
      )
    
  })
  
}

shinyApp(ui, server)
