coh<-read.csv("cohort.csv")
head(coh2)
str(coh)
?unique
coh2<-unique(coh)
apply(coh2,2,function(x) sum(is.na(x)))
coh2<-coh2[complete.cases(coh2),]
#converting into date format and taking only 2011 data
coh2$InvoiceDate<-as.Date(coh2$InvoiceDate,format = "%m/%d/%Y")
str(coh2)

coh2$year<-as.numeric(format(coh2$InvoiceDate, '%Y'))
coh2011<-coh2[coh2$year==2011,]
coh2011<-coh2011[,c('CustomerID','InvoiceDate','year')]
