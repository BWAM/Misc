# set back to the working directory
setwd("C:/Rscripts/RIBS.Analysis/Combined.Data")
data<-read.csv("RIBS.complete.csv")

data$Parameter<-gsub("Nitrate\\+Nitrite.+","Nitrate+Nitrite (mg/L)",data$Parameter)
data$Parameter<-gsub(".+Nitrate-Nitrite.+","Nitrate+Nitrite (mg/L)",data$Parameter)
data$Parameter<-gsub(".+Nitrite + Nitrate.+","Nitrate+Nitrite (mg/L)",data$Parameter)
data$Parameter<-gsub(".+KJELDAHL.+","TKN (mg/L)",data$Parameter)
data$Parameter<-gsub(".+Kjeldahl.+","TKN (mg/L)",data$Parameter)
data$Parameter<-gsub("NITROGEN, NITRATE.+","Nitrate (mg/L)",data$Parameter)
data$Parameter<-gsub("Nitrogen, Nitrate.+","Nitrate (mg/L)",data$Parameter)
data$Parameter<-gsub("NITROGEN, NITRITE.+","Nitrite (mg/L)",data$Parameter)
data$Parameter<-gsub("Nitrogen, Nitrite.+","Nitrite (mg/L)",data$Parameter)


params = c('Nitrate+Nitrite (mg/L)','TKN (mg/L)','Nitrate (mg/L)','Nitrite (mg/L)')

NiNa<-data[(data$Parameter==params[1]),]
names(NiNa)[names(NiNa)=="Result.Value"]<-params[1]
err <- paste(params[1]," error")
names(NiNa)[names(NiNa)=="Error_Flag"]<-err
keep<-c("Station","SAMPLE_DATE","Nitrate+Nitrite (mg/L)","Nitrate+Nitrite (mg/L)  error")
NiNa<-NiNa[keep]

TKN<-data[(data$Parameter==params[2]),]
names(TKN)[names(TKN)=="Result.Value"]<-params[2]
err <- paste(params[2]," error")
names(TKN)[names(TKN)=="Error_Flag"]<-err
keep<-c("Station","SAMPLE_DATE","TKN (mg/L)","TKN (mg/L)  error")
TKN<-TKN[keep]

Nitrate<-data[(data$Parameter==params[3]),]
names(Nitrate)[names(Nitrate)=="Result.Value"]<-params[3]
err <- paste(params[3]," error")
names(Nitrate)[names(Nitrate)=="Error_Flag"]<-err
keep<-c("Station","SAMPLE_DATE","Nitrate (mg/L)","Nitrate (mg/L)  error")
Nitrate<-Nitrate[keep]

Nitrite<-data[(data$Parameter==params[4]),]
names(Nitrite)[names(Nitrite)=="Result.Value"]<-params[4]
err <- paste(params[4]," error")
names(Nitrite)[names(Nitrite)=="Error_Flag"]<-err
keep<-c("Station","SAMPLE_DATE","Nitrite (mg/L)","Nitrite (mg/L)  error")
Nitrite<-Nitrite[keep]

rm(list=c('err','keep','params'))

nutrients <- merge(NiNa,TKN,by=c("Station","SAMPLE_DATE"),all=TRUE)
nutrients <- merge(nutrients,Nitrate,by=c("Station","SAMPLE_DATE"),all=TRUE)
nutrients <- merge(nutrients,Nitrite,by=c("Station","SAMPLE_DATE"),all=TRUE)
rm(list=c('NiNa','Nitrate','Nitrite','TKN'))

#Calculating TN from NiNa and TKN
TNnina<-nutrients[!is.na(nutrients$`Nitrate+Nitrite (mg/L)`),]
TNnina<-nutrients[!is.na(nutrients$`TKN (mg/L)`),]
TNnina$TNnina <- TNnina$`Nitrate+Nitrite (mg/L)`+TNnina$`TKN (mg/L)`

#Calculating TN from Ni and Na and TKN
TNnsn<-nutrients[!is.na(nutrients$`TKN (mg/L)`),]
TNnsn<-nutrients[!is.na(nutrients$`Nitrate (mg/L)`),]
TNnsn<-nutrients[!is.na(nutrients$`Nitrite (mg/L)`),]
TNnsn$TNnsn<-TNnsn$`TKN (mg/L)`+TNnsn$`Nitrate (mg/L)`+TNnsn$`Nitrite (mg/L)`
#merge with nutrients field
temp<-merge(TNnina,TNnsn,by=c("Station","SAMPLE_DATE","Nitrate+Nitrite (mg/L)","Nitrate+Nitrite (mg/L)  error","TKN (mg/L)","TKN (mg/L)  error","Nitrate (mg/L)","Nitrate (mg/L)  error","Nitrite (mg/L)","Nitrite (mg/L)  error"),all=TRUE)
nutrients<-merge(temp,nutrients,by=c("Station","SAMPLE_DATE","Nitrate+Nitrite (mg/L)","Nitrate+Nitrite (mg/L)  error","TKN (mg/L)","TKN (mg/L)  error","Nitrate (mg/L)","Nitrate (mg/L)  error","Nitrite (mg/L)","Nitrite (mg/L)  error"),all=TRUE)

#remove duplicates
nutrients<-unique(nutrients[c("Station","SAMPLE_DATE","Nitrate+Nitrite (mg/L)","Nitrate+Nitrite (mg/L)  error","TKN (mg/L)","TKN (mg/L)  error","Nitrate (mg/L)","Nitrate (mg/L)  error","Nitrite (mg/L)","Nitrite (mg/L)  error","TNnina","TNnsn")])

#write table
write.csv(nutrients,file="nutrients.csv",row.names=FALSE)