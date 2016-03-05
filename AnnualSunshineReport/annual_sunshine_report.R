# Read sunshine data
data<-read.csv("1325708_42.33_-71.1_2014_headless.csv")
data$date<-ISOdatetime(data$Year, data$Month, data$Day, 0 , 0, 0)
data$time<-ISOdatetime(2016, 01, 01, data$Hour, data$Minute, 0)
data$sunshine<-sapply(data$DNI, function(x) x>0)

# Plot sunshine data
x11()
plot.new()
plot(data$date, data$time, type="n", axes=F)
par(mar=c(1, 1, 3, 1))
mtext("Annual Sunshine Record", side=3, cex=1.5, line=1.5)
mtext("Boston, MA - 2014", side=3, cex=1, line=.25)
for (i in 1:(length(data$sunshine)-1)) {
  if (data$sunshine[i] == TRUE){
    x<-c(data$date[i], data$date[i+1])
    y<-c(data$time[i], data$time[i+1])
    lines(x, y, lwd=4, lend="butt")
  }
}

# Generate x-axis variables
xtics<-as.POSIXct(rep(NA, 25))
xlabs<-rep(NA, 25)
for (i in 0:length(xtics)){
  x<-ISOdatetime(2016, 01, 01, i, 0, 0)
  xtics[i]<-x
  xlabs[i]<-i
}
xtics[25]<-ISOdatetime(2016, 01, 02, 0, 0, 0)
xlabs[25]<-0

# Generate y-axis variables
ytics<-as.POSIXct(rep(NA, 13))
for (i in 1:length(ytics)){
  y<-ISOdatetime(2014, i, 1, 0, 0, 0)
  ytics[i]<-y
}
ytics[13]<-ISOdatetime(2015, 01, 01, 0, 0, 0)
ylabs<-c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan")

# Generate axes and labels
axis(1, at=ytics, labels=ylabs, tck=-.01, cex.lab=.1, cex.axis=.7, pos=xtics[1], mgp=c(0, .2, 0))
axis(3, at=ytics, labels=rep(NA, 13), tck=0, cex.axis=.7, pos=xtics[25])
axis(2, at=xtics, labels=xlabs, tck=-.005, cex.axis=.7, pos=ytics[1], mgp=c(0, .2, 0))
axis(2, at=xtics, labels=rep(NA, 25), tck=0, cex.axis=.7, pos=ytics[13])
mtext("NOON", side=2, cex=.75, line=-1, at=ISOdatetime(2016, 01, 01, 12, 0, 0))
mtext("MIDNIGHT", side=2, cex=.75, line=-1, at=ISOdatetime(2016, 01, 01, 1, 0, 0))
mtext("MIDNIGHT", side=2, cex=.75, line=-1, at=ISOdatetime(2016, 01, 01, 24, 0, 0))




# Read sunset and sunrise data
ss<-read.table("sunset_sunrise_raw.txt", na.strings="-", skip=9, fill=TRUE)
ss<-ss[,2:25]  # remove the day column
sunrise<-as.POSIXct(rep(NA, 365))  # actually get number of none NA values in ss
sunset<-as.POSIXct(rep(NA, 365))
date<-as.POSIXct(rep(NA, 365))
rise_index<-1
set_index<-1
date_index<-1
month<-1

for (j in 1:dim(ss)[1]){ # Walk through columns, 2xmonth
  for (i in 1:dim(ss)[1]){  # Walk through rows, day
    d<-ISOdatetime(2014, month, i, 0, 0, 0)
    if(!is.na(d)){  # don't add data for days like feb 31
      min<-ss[i,j]%%100
      hour<-(ss[i,j] - min) / 100
      t<-ISOdatetime(2016, 1, 1, hour, min, 0)
      if (j%%2 == 1){  # Sunrise column
        date[date_index]<-d
        date_index<- date_index+1
        sunrise[rise_index]<-t
        rise_index <- rise_index + 1
      } else{
        sunset[set_index]<-t
        set_index<- set_index + 1
      }
    }
  }
  if (j%%2 == 0){month<-month+1}
}

ss_data<-data.frame(date, sunset, sunrise)
names(ss_data)<-c("date", "sunset", "sunrise")

# Plot sunset/rise data
for (i in 1:length(ss_data$sunset)){
  points(ss_data$date[i], ss_data$sunset[i], pch=".")
  points(ss_data$date[i], ss_data$sunrise[i], pch=".")
}
p=25
text(ss_data$date[p], ss_data$sunset[p], "Sunset", pos=3, cex=.6)
text(ss_data$date[p], ss_data$sunrise[p], "Sunrise", pos=1, cex=.6)