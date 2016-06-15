rm(list=ls()) #clear all variables and packages

library(ggplot2)

### inputting the streaming dataframe ###
data = read.table("~/Desktop/parsed.times.txt", header = F, sep = " ")
names(data) = c("Steps", "Event", "Stamp")
data$Steps = as.factor(data$Steps) #converting values into factors
data$Event = as.factor(data$Event)
data$Stamp = as.numeric(data$Stamp)

streamingsteps = length(levels(data$Steps)) # handy variable for later

### inputting the nonstreaming dataframe ###
data3 = read.table("~/Desktop/parsed.times.txt", header = F, sep = " ")
names(data3) = c("Steps", "Event", "Stamp")
data3$Steps = as.factor(data3$Steps) #converting values into factors
data3$Event = as.factor(data3$Event)
data3$Stamp = as.numeric(data3$Stamp)

nonstreamingsteps = length(levels(data3$Steps))


#creating data2 (type==matrix) with 'distributions'
data2 = data.frame(matrix(NA, nrow = (streamingsteps+nonstreamingsteps)*6, ncol = 3, dimnames = list(NULL,c('Steps','Time','Method'))))
data2$Steps = c(rep(levels(data$Steps), each=6), rep(levels(data3$Steps),each=6))
data2$Method = c(rep('Streaming', streamingsteps*6),rep('Non-Streaming', nonstreamingsteps*6))


for (each in levels(data$Steps)) {
  indy1 = which(data$Steps==each & data$Event=='START')
  indy2 = which(data$Steps==each & data$Event=='DONE')
  data2[which(data2$Steps==each & data2$Method=='Streaming'),2] = c(rep(data[indy1,3],3),rep(data[indy2,3],3)) 
                                                                  #repeats start time and end time 5x
                                                                  # each in the correspoding matrix rows
}

for (every in levels(data3$Steps)) {
  indy1 = which(data3$Steps==every & data3$Event=='START')
  indy2 = which(data3$Steps==every & data3$Event=='DONE')
  data2[which(data2$Steps==every & data2$Method=='Non-Streaming'),2] = c(rep(data3[indy1,3],3),rep(data3[indy2,3],3))
  # each in the correspoding matrix rows
}


data2$Steps = as.factor(data2$Steps) # designate pipeline steps as factors
data2$Time = as.numeric(data2$Time)

### build the plot (coloring by step)
plot = ggplot(data2, aes(x=Steps, y=Time, color=Steps)) 
plot = plot + geom_boxplot()                              # plot with steps on the x axis 
                                                          # because coords will be flipped after
plot = plot + scale_x_discrete(limits = rev(levels(data2$Steps))) # custom order the steps
plot = plot + coord_flip()  # flip the coordinates
 
plot

# for later: combining non-streaming and streaming
plot = ggplot(data2, aes(x=Steps, y=Time, fill = Method)) #method will need to contain either
                                                          #streaming or non-streaming, and
                                                          #streaming will need its own 'distributions'
plot = plot + geom_boxplot() 
plot = plot + geom_boxplot(position = position_dodge(1))
plot = plot + scale_x_discrete(limits = rev(levels(data2$Steps))) # custom order the steps
plot = plot + coord_flip()  # flip the coordinates

plot


