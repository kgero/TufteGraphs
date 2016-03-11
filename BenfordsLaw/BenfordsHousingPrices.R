# Data source: http://www.zillow.com/research/data/
# Much inspiration from R Tufte Graph examples (http://motioninsocial.com/tufte/)
# Requires ggplot2 and ggthemes

library(ggplot2)
library(ggthemes)

data<-read.csv("State_Zhvi_SingleFamilyResidence.csv")
only_nums<-rep(NA, dim(data)[1] * (dim(data)[2]-3))
first_digit<-rep(NA, length(only_nums))

k<-0
for(i in 1:dim(data)[1]){
  for(j in 4:dim(data)[2]){
    k<-k+1
    only_nums[k]<-data[i, j]
    first_digit[k]<-as.numeric(head(strsplit(as.character(data[i, j]),"")[[1]],n=1))
  }
}

x<-c("1", "2", "3", "4", "5", "6", "7", "8", "9")
y<-rep(0, 9)

for(i in 1:9){
  y[i]<-length(which(first_digit==i))
}
total<-sum(y)
for(i in 1:9){
  y[i]<- y[i]/total
}
df<-data.frame(x, y)

ggplot(df, aes(x=x, y=y)) + theme_tufte(base_size=14, ticks=F) +
  geom_bar(width=0.25, fill="gray", stat = "identity") +  theme(axis.title=element_blank()) +
  scale_y_continuous(breaks=seq(.1, 1, .1)) + 
  geom_hline(yintercept=seq(.1, 1, .1), col="white", lwd=1) +
  coord_fixed(ratio=5) +
  annotate("text", x=5, y=1, size=5, family="serif",
           label=c("Benford's Law: Zillow Home Value Index (ZHVI)")) +
  annotate("text", x = 9, y = .7, size=3, adj=1, family="serif",
           label = c("First digits
                     of ZHVI for Single Family Homes
                     Monthly, 04-1996 through 01-2016
                     for each of the lower 48 states of U.S.A.
                     (http://www.zillow.com/research/data/)"))

