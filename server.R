library(shiny)
library(ggmap)
library(ggplot2)
library(dplyr)

citations=read.csv('./Citations_Munged.csv')
citations$Day=as.Date(citations$Day)
citations$Month=as.Date(citations$Month)
citations$Week=as.Date(citations$Week)
citations$dateTime=as.POSIXct(citations$dateTime)
citations$chgCategory=as.character(citations$chgCategory)
#citeSamp<-sample_n(citations,10)
mapImage <- get_googlemap(center=c(-71.1025,42.3975),maptype='roadmap',filename='mapImageFile',format='png8',zoom=13,where='/home/matt/Desktop')

shinyServer(function(input,output){
  filtDat <- reactive({
    if(!is.null(input$Days)|!is.null(input$viol)){filter(citations,dayOfWeek %in% input$Days & dateTime>as.POSIXct(input$dRange[1]) & dateTime<as.POSIXct(input$dRange[2]) & chgCategory %in% input$viol & Hour >= input$tRange[1] & Hour <= input$tRange[2])}
    else{data.frame(X=0,Y=0,chgCategory="Other")}
  })
  totCharge <- reactive({  if(!is.null(input$Days)|!is.null(input$viol)){dim(filter(citations,dayOfWeek %in% input$Days & dateTime>as.POSIXct(input$dRange[1]) & dateTime<as.POSIXct(input$dRange[2])  & Hour >= input$tRange[1] & Hour <= input$tRange[2]))[1]}
    else{0}
    })
  
  #x <- reactive({match(names(filtDat()),catVec)})
  #vec <- rep('\n',length(catVec))
  #vec[y] <- x()
  #vec <- vec[-length(vec)]})
  #output$numByCategory <- renderPrint({x()})
  #output$numByDayOfWeek <- renderPrint({table(filtDat$dayOfWeek)})
  output$citationPlot <- renderPlot({ggmap(mapImage,extent="device")+geom_jitter(data=filtDat(),aes(x=X,y=Y,color=as.factor(chgCategory),shape=as.factor(chgCategory)),size=3,alpha=.65,width=.001,height=.001)+
     xlab('Longitude')+ylab('Latitude')+labs(color="Charge",shape="Charge")+xlim(c(-71.14,-71.075))+ylim(c(42.375,42.42))})
  output$citationBar <- renderPlot({ggplot(data=filtDat(),aes(x=chgCategory,fill=as.factor(chgCategory)))+geom_bar()+ggtitle('Histogram')+xlab('')+labs(fill='Charge')+theme(axis.text=element_text(size=16),title=element_text(size=20),axis.title=element_text(size=18),legend.text=element_text(size=14),axis.text.x=element_text(angle=25,hjust=1))})
  output$tab <- renderDataTable({
    rawTab <- cbind(table(filtDat()$chgCategory),table(filtDat()$chgCategory)/totCharge()*100)
    dfTab <- data.frame(row.names(rawTab),rawTab,row.names=NULL)
    names(dfTab)=c('Charge','Number of Citations','% of total')
    dfTab
    },options=list(paging=F,searching=F,lengthChange=F,info=F))
  output$timeSeries <- renderPlot({ggplot(data=filtDat(),aes(x=Day,color=chgCategory,group=chgCategory,fill=chgCategory))+geom_histogram(binwidth=7)+xlab('Week')+ylab('Number of citations')+ggtitle('Citations by week')+labs(fill='Charge',color='Charge',group='Charge')+
      theme(axis.text=element_text(size=16),title=element_text(size=20),axis.title=element_text(size=18),legend.text=element_text(size=14))})
  output$timeHist <- renderPlot({ggplot(data=filtDat(),aes(x=Hour,color=chgCategory,group=chgCategory,fill=chgCategory))+geom_histogram(binwidth=1)+xlab('Hour')+ylab('Number of citations')+ggtitle('Citations over the day')+labs(fill='Charge',color='Charge',group='Charge')+
      theme(axis.text=element_text(size=16),title=element_text(size=20),axis.title=element_text(size=18),legend.text=element_text(size=14))})
  })
 

