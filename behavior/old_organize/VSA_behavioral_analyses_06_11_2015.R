library(reshape)
library(ggplot2)
library(plyr)
### CLEAN WORKSPACE ###
rm(list=ls())


listsubjects = list.files('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/results/VSA/')


dataAll = c()

for(subIdx in 1:length(listsubjects)) {


#path = sprintf("/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/results/VSA/%s", listsubjects[sub])

% Define paths
resultpath = sprintf("/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/results/VSA/%s", listsubjects[subIdx])
stimpath = sprintf("/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/stimuli/VSA/%s/", listsubjects[subIdx])
setwd(resultpath)

data1 <- read.csv('1_results.csv')
data2 <- read.csv('2_results.csv')
data3 <- read.csv('3_results.csv')
data4 <- read.csv('4_results.csv')

# For subject 1
#data1 <- read.csv('1_results.csv', sep=';')
#data2 <- read.csv('2_results.csv', sep=';')
#data3 <- read.csv('3_results.csv', sep=';')
#data4 <- read.csv('4_results.csv', sep=';')


data <- rbind(data1, data2, data3, data4)

data <- data[data$myEvent=='T'|data$myEvent=='L',]
 
data$response <- toupper(data$response)

run1 <- read.csv(paste(stimpath,'run1.csv', sep=''))
run2 <- read.csv(paste(stimpath,'run2.csv', sep=''))
run3 <- read.csv(paste(stimpath,'run3.csv', sep=''))
run4 <- read.csv(paste(stimpath,'run4.csv', sep=''))

runs = rbind(run1, run2, run3, run4)

data$congruency <- runs$Congruency

data$delay <- runs$Delay

data$congruency <- as.factor(data$congruency)
data$position <- runs$Position
data <- data[data$delay!=1,]

datamiss <- data[data$response == 0,]
data <- data[data$response != 0,]
misscong <- summary(datamiss$congruency)

data$response = factor(data$response)
data$myEvent = factor(data$myEvent)

data_correct <- data[data$response == data$myEvent,]
data_incorrect <- data[data$response != data$myEvent,]

summary(data_correct$congruency)
summary(data_incorrect$congruency)

#data <- data_correct 

### Data trimmig reaction times
## REACTION TIMES
# Data trimming
# Defifing objects for the loops
RTdata_b <- c()
RTdata_trimmed <- c()
# Defifing data trimming factor 
datatrimming_factor = 3

#for(i in 1:dim(data)[1]){
	RTdata <- as.matrix(data$rt)
	#RTdata[data[[i]]$answer == 0] <- NA
	while (!identical(RTdata_b, RTdata)) {
		meanRT <- apply(RTdata, 2, mean, na.rm=T)
		sdRT <- apply(RTdata, 2, sd, na.rm=T)
		interval_high <- meanRT+datatrimming_factor*sdRT
		interval_low <- meanRT-datatrimming_factor*sdRT
		obj <- mapply(function(i){as.matrix(as.numeric(RTdata[,i] <= interval_high[i]), nrow=dim(RTdata)[1])}, 1:dim(RTdata)[2])
		RTdata[obj==0] <- NA
		RTdata_b <- RTdata
		}
#RTdata_trimmed[i] <- RTdata_b
#}
data$RTdata_b <- RTdata_b


data <- data[!is.na(RTdata_b),]

boxplot(data$rt ~ data$congruency)

by(data$rt, data$congruency, mean)
by(data$rt, data$congruency, sd)

rt_congruent <- data[data$congruency ==0,5]
rt_incongruent <- data[data$congruency ==1,5]

testeffect = t.test(rt_congruent, rt_incongruent)
testeffect$p.value

data_correct <- data[data$response == data$myEvent,]
data_incorrect <- data[data$response != data$myEvent,]

datancorr <- summary(data_correct$congruency)
datanincorr <- summary(data_incorrect$congruency)

dataAll[[subIdx]]= data

}


# Plot w congruent and incongruent
mean_plot <- ddply(data, "congruency", summarise, rt = mean(rt))
mean_plot$congruency <- c('Valid', 'Invalid')
sd_plot <- ddply(data, "congruency", summarise, std = sd(rt))
n_obs <- c(length(which(data$congruency=='0')),length(which(data$congruency=='1')))
data_plot <- data.frame(cbind(mean_plot, sd_plot[,2], n_obs, sd_plot[,2]/sqrt(n_obs)))
colnames(data_plot) <-  c('Congruency','mean','sd','n', 'se')
maxRT = max(data_plot[2])+200




plot_data <- ggplot(data_plot, aes(x=Congruency, y=mean,fill=Congruency, width=.5)) + geom_bar(position ='identity' , stat='identity') + geom_errorbar(aes(ymin=mean-se,ymax=mean+se),position=position_dodge(.5),width=.01) + scale_fill_manual(values=c("grey", "grey")) + labs(y = "RT") + theme_bw() + theme(legend.position="none") + scale_y_continuous(limits=c(0, maxRT),breaks=seq(0, 2000, 50)) + theme(axis.title.x = element_blank()) + theme(text = element_text(size=20)) + ggtitle(sprintf("VSA %s", subjname)) + geom_text(data = NULL, x = 1, y = 150, label = sprintf("%s trials", data_plot$n[2])) + geom_text(data = NULL, x = 1, y = 100, label = sprintf("%s correct", datancorr[2])) + geom_text(data = NULL, x = 2, y = 100, label = sprintf("%s correct", datancorr[1])) + geom_text(data = NULL, x = 1, y = 50, label = sprintf("%s incorrect", datanincorr[2])) + geom_text(data = NULL, x = 2, y = 50, label = sprintf("%s incorrect", datanincorr[1])) + geom_text(data = NULL, x = 2, y = 150, label = sprintf("%s trials", data_plot$n[1])) + geom_text(data = NULL, x = 1.5, y = maxRT, label = sprintf("p = %s", round(testeffect$p.value, digits=3))) + geom_text(data = NULL, x = 1.5, y = 150, label = sprintf("%s miss", dim(datamiss)[1])) + geom_text(data = NULL, x = 1.5, y = 100, label = sprintf("%s valid", misscong[1])) + geom_text(data = NULL, x = 1.5, y = 50, label = sprintf("%s invalid", misscong[2])) 


ggsave(file=sprintf("plot_data_correct_%s.eps", subjname), plot= plot_data, width=6, height=6)





# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)

  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)

  numPlots = length(plots)

  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                    ncol = cols, nrow = ceiling(numPlots/cols))
  }

 if (numPlots==1) {
    print(plots[[1]])

  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))

    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))

      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}


