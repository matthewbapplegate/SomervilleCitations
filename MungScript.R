library(lubridate)

catVec = c('Bicycle Violation','Drugs', 'DUI','Failure to Stop/Yield','Hit and Run','Inspection Violation', 'License','Litter','Speeding','Texting','Other')

citations2 = read.csv('./data/Police_-_Motor_Vehicle_Citations.csv')
citations2$dateTime = parse_date_time(citations2$dtissued,'m%d%Y %I%M%S %p')
citations2$Month <- as.Date(cut(citations2$dateTime,breaks="month"))
citations2$Week <- as.Date(cut(citations2$dateTime,breaks="week"))
citations2$Day <- as.Date(cut(citations2$dateTime,breaks="day"))
citations2$dayOfWeek <-weekdays(as.Date(citations2$dateTime))
citations2$Hour <- as.numeric(substr(citations2$dateTime,12,13))
citations2$chgCategory = "Other"
iDrugs = with(citations2, grepl("DRUGS",chgdesc))
iInspection = with(citations2,grepl("INSPECTION",chgdesc))
iBicycle = with(citations2, grepl("BICYCLE",chgdesc))
iStopYield = with(citations2,grepl("STOP.YIELD",chgdesc))
iSpeeding = with(citations2,grepl("SPEEDING",chgdesc))
iOUI1 = with(citations2,grepl("OUI",chgdesc))
iOUI2 = with(citations2,grepl("ALCOHOL",chgdesc))
iOUI=iOUI1|iOUI2
iText = with(citations2,grepl("ELEC",chgdesc))
iHitnRun = with(citations2,grepl("LEAVE SCENE",chgdesc))
iLitter = with(citations2,grepl("LITTERING", chgdesc))
iLicense = with(citations2,grepl("LICENSE",chgdesc))

citations2$chgCategory[iInspection] <- 'Inspection Violation'
citations2$chgCategory[iBicycle] <- 'Bicycle Violation'
citations2$chgCategory[iStopYield] <- 'Failure to Stop/Yield'
citations2$chgCategory[iSpeeding] <- 'Speeding'
citations2$chgCategory[iOUI] <- 'DUI'
citations2$chgCategory[iText] <- 'Texting'
citations2$chgCategory[iHitnRun]<-'Hit and Run'
citations2$chgCategory[iLitter]<-'Litter'
citations2$chgCategory[iLicense]<-'License'
citations2$chgCategory[iDrugs]<-'Drugs'

write.table(citations2,file='./shiny_map/citations2_Munged.csv',row.names=F,sep=',')