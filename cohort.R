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
head(coh2011)

?aggregate
join.date <- aggregate(InvoiceDate~CustomerID,coh2011,min, na.rm = TRUE)
head(join.date)

colnames(join.date)[2] <- "Join_Date"
head(join.date)

?merge
coh2011 <- merge(coh2011, join.date, by.x = "CustomerID",by.y = "CustomerID", all.x = TRUE)
head(coh2011)


coh2011$Cohort <- as.numeric(format(coh2011$Join_Date, "%m"))
head(coh2011)


#install.packages("DT")
#library(DT)
#DT::datatable(head(coh2011,500),
              filter = 'top',
              rownames = FALSE,
              options = list(
                pageLength = 10,
                pageLength = c(10,20,30,40,50)))


coh2011$Age_by_Day <- as.numeric(difftime(coh2011$InvoiceDate,coh2011$Join_Date,units = c("days")))
head(coh2011)


coh2011$Age_by_Month <- floor(coh2011$Age_by_Day/30)
head(coh2011)


coh2011$Join_Date <- format(coh2011$Join_Date, "%Y-%m")
coh2011$InvoiceDate <- format(coh2011$InvoiceDate, "%Y-%m")
head(coh2011)



groups <- c("Jan Cohorts",
            "Feb Cohorts",
            "Mar Cohorts",
            "Apr Cohorts",
            "May Cohorts",
            "Jun Cohorts",
            "Jul Cohorts",
            "Aug Cohorts",
            "Sep Cohorts",
            "Oct Cohorts",
            "Nov Cohorts",
            "Dec Cohorts")

for(i in 1:12){
  coh2011[coh2011$Cohort==i,"Cohort"] <- groups[i]
}
head(coh2011)



coh2011$Cohort <- factor(coh2011$Cohort,ordered = T,levels =c("Jan Cohorts",
                                                                      "Feb Cohorts",
                                                                      "Mar Cohorts",
                                                                      "Apr Cohorts",
                                                                      "May Cohorts",
                                                                      "Jun Cohorts",
                                                                      "Jul Cohorts",
                                                                      "Aug Cohorts",
                                                                      "Sep Cohorts",
                                                                      "Oct Cohorts",
                                                                      "Nov Cohorts",
                                                                      "Dec Cohorts"))

dupes <- which(duplicated(coh2011[,c(-5,-6)]))
head(dupes)
dupes[1:10]

coh2011 <- coh2011[-dupes,]
head(coh2011)
tail(coh2011)

?reshape2::dcast
cohorts.wide <- reshape2::dcast(coh2011,Cohort~Age_by_Month,
                                value.var="CustomerID",
                                fun.aggregate = length)

