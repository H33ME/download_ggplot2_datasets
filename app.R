#### download datasets from the ggplot packages using shiny App

library(ggplot2)
library(shiny)

ui<- fluidPage(
    selectInput("dataset","Dataset",choices=data(package="ggplot2")$result[,"Item"]),
    tableOutput("sneak_peak"),
    downloadButton("download","Download ggplot2 .tsv file")
)

server<- function(input,output,session){
    dat<- reactive({
        out<- get(input$dataset,"package:ggplot2")
        
        if(!is.data.frame(out)){
            validate("'", input$dataset, "' is not a dataframe thus cannot be downloaded")
        }
        out
    })
    output$sneak_peak<- renderTable({
        head(dat())
    })
    output$download<- downloadHandler(
        filename = function(){
            paste0(input$dataset,".tsv")
        },
        content = function(file){
            vroom::vroom_write(dat(),file)
        }
    )
}

shinyApp(ui,server)

