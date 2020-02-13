library(reshape)
library(ggplot2)
library(plyr)
### CLEAN WORKSPACE ###
rm(list=ls())

# Define the subject
subjname = 'sub1'

# Define the paths
stimdir = sprintf("/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/stimuli/Calc/%s", subjname)
resultsdir = sprintf("/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/data/results/Calc/%s", subjname)
setwd(resultsdir)
setwd(stimdir)

# Function to load all the data and put together in a single dataframe
load_data <- function(path) { 
	files <- dir(path, pattern = '\\.csv', full.names = TRUE)
	tables <- lapply(files, read.csv, header = FALSE )
	do.call(rbind, tables)
}

load_data2 <- function(path) { 
	files <- dir(path, pattern = '\\.csv', full.names = TRUE)
	tables <- lapply(files, read.csv, header = TRUE )
	do.call(rbind, tables)
}

# Load the stim and the results
runs <- load_data(stimdir)
dim(runs)
data <- load_data2(resultsdir)
dim(data)


# Reshape myEvent to retrieve stimlist and compare to runs
opsData <- matrix(data$myEvent,ncol=5, byrow=T)
opsRuns <- as.matrix(runs[,1:5])
opsData == opsRuns

# Select only the responses
dataResp <- data[data$response != 99,]

# Add correct response and deviants
runs$answerCorr <- runs[,1]+(runs[,2]/10)*runs[,3]
runs$answerCorr[runs$answerCorr>100] = runs[runs$answerCorr>100,1]
runs$responseCorr <- runs[,5]==runs[,7]
runs$deviant <- abs(runs[,5]-runs[,7])

dataResp$responseCorr <- runs$responseCorr
dataResp$deviant <- runs$deviant 
dataResp$deviant <- as.factor(dataResp$deviant)

dataResp$accuracy <- dataResp$responseCorr == dataResp$response
dataResp$operation <- runs[,2]

data_add <- dataResp[dataResp$operation == 10,]
data_sub <- dataResp[dataResp$operation == -10,]
data_comp <- dataResp[dataResp$operation == 99,]

boxplot(rt ~ deviant, data= data_comp)


# Additions
# Plot w congruent and incongruent
mean_plot <- ddply(data_add, "deviant", summarise, rt = mean(rt))
ndeviants <- as.matrix(summary(data_add$deviant))
mean_plot$deviant <- c('0','1','2','3','4')
sd_plot <- ddply(data_add, "deviant", summarise, std = sd(rt))
n_obs <- ndeviants
data_plot <- data.frame(cbind(mean_plot, sd_plot[,2], n_obs, sd_plot[,2]/sqrt(n_obs)))
colnames(data_plot) <-  c('Congruency','mean','sd','n', 'se')

plot_data <- ggplot(data_plot, aes(x=Congruency, y=mean,fill=Congruency, width=.5)) + geom_bar(position ='identity' , stat='identity') + geom_errorbar(aes(ymin=mean-se,ymax=mean+se),position=position_dodge(.5),width=.01) + scale_fill_manual(values=c("grey", "grey","grey","grey","grey")) + labs(y = "RT") + labs(x = "Deviant") + theme_bw() + theme(legend.position="none") + scale_y_continuous(limits=c(0,1500),breaks=seq(0, 1500, 100)) + theme(text = element_text(size=20)) + ggtitle(sprintf("Addition %s", subjname)) 
ggsave(file=sprintf("plot_addition_%s.eps", subjname), plot= plot_data, width=6, height=6)

# Subtractions
# Plot w congruent and incongruent
mean_plot <- ddply(data_sub, "deviant", summarise, rt = mean(rt))
ndeviants <- as.matrix(summary(data_sub $deviant))
mean_plot$deviant <- c('0','1','2','3','4')
sd_plot <- ddply(data_sub, "deviant", summarise, std = sd(rt))
n_obs <- ndeviants
data_plot <- data.frame(cbind(mean_plot, sd_plot[,2], n_obs, sd_plot[,2]/sqrt(n_obs)))
colnames(data_plot) <-  c('Congruency','mean','sd','n', 'se')

plot_data <- ggplot(data_plot, aes(x=Congruency, y=mean,fill=Congruency, width=.5)) + geom_bar(position ='identity' , stat='identity') + geom_errorbar(aes(ymin=mean-se,ymax=mean+se),position=position_dodge(.5),width=.01) + scale_fill_manual(values=c("grey", "grey","grey","grey","grey")) + labs(y = "RT") + labs(x = "Deviant") + theme_bw() + theme(legend.position="none") + scale_y_continuous(limits=c(0,1500),breaks=seq(0, 1500, 100)) + theme(text = element_text(size=20)) + ggtitle(sprintf("Subtractions %s", subjname)) 
ggsave(file=sprintf("plot_subtractions_%s.eps", subjname), plot= plot_data, width=6, height=6)

# Comparions
# Plot w congruent and incongruent
mean_plot <- ddply(data_comp, "deviant", summarise, rt = mean(rt))
ndeviants <- as.matrix(summary(data_comp $deviant))
mean_plot$deviant <- c('0','1','2','3','4')
sd_plot <- ddply(data_comp, "deviant", summarise, std = sd(rt))
n_obs <- ndeviants
data_plot <- data.frame(cbind(mean_plot, sd_plot[,2], n_obs, sd_plot[,2]/sqrt(n_obs)))
colnames(data_plot) <-  c('Congruency','mean','sd','n', 'se')

plot_data <- ggplot(data_plot, aes(x=Congruency, y=mean,fill=Congruency, width=.5)) + geom_bar(position ='identity' , stat='identity') + geom_errorbar(aes(ymin=mean-se,ymax=mean+se),position=position_dodge(.5),width=.01) + scale_fill_manual(values=c("grey", "grey","grey","grey","grey")) + labs(y = "RT") + labs(x = "Deviant") + theme_bw() + theme(legend.position="none") + scale_y_continuous(limits=c(0,1500),breaks=seq(0, 1500, 100)) + theme(text = element_text(size=20)) + ggtitle(sprintf("Comparisons %s", subjname)) 
ggsave(file=sprintf("plot_comparisons_%s.eps", subjname), plot= plot_data, width=6, height=6)



summary(aov(rt ~ deviant, data= data_add))



















+ geom_text(data = NULL, x = 1, y = 500, label = sprintf("%s trials", data_plot$n[2])) 




+ geom_text(data = NULL, x = 1, y = 400, label = sprintf("%s correct", datancorr[2])) 




+ geom_text(data = NULL, x = 2, y = 400, label = sprintf("%s correct", datancorr[1])) + geom_text(data = NULL, x = 1, y = 300, label = sprintf("%s incorrect", datanincorr[2])) + geom_text(data = NULL, x = 2, y = 300, label = sprintf("%s incorrect", datanincorr[1])) + geom_text(data = NULL, x = 2, y = 500, label = sprintf("%s trials", data_plot$n[1])) + geom_text(data = NULL, x = 1.5, y = 1100, label = sprintf("p = %s", round(testeffect$p.value, digits=3))) + geom_text(data = NULL, x = 1.5, y = 500, label = sprintf("%s miss", dim(datamiss)[1])) + geom_text(data = NULL, x = 1.5, y = 400, label = sprintf("%s valid", misscong[1])) + geom_text(data = NULL, x = 1.5, y = 300, label = sprintf("%s invalid", misscong[2]))



# Work from here













data <- read.csv('1_results.csv')


data2 <- read.csv('2_results.csv')
data3 <- read.csv('3_results.csv')
data4 <- read.csv('4_results.csv')
data5 <- read.csv('1_results.csv')
data6 <- read.csv('2_results.csv')
data3 <- read.csv('3_results.csv')
data4 <- read.csv('4_results.csv')
data3 <- read.csv('3_results.csv')
data4 <- read.csv('4_results.csv')

data <- rbind(data1, data2, data3, data4)

data <- data[data$myEvent=='T'|data$myEvent=='L',]
 
data$response1 <- toupper(data$response)

path = sprintf("/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/experiment/stimuli/VSA/%s", subjname)
setwd(path)

run1 <- read.csv('run1.csv')
run2 <- read.csv('run2.csv')
run3 <- read.csv('run3.csv')
run4 <- read.csv('run4.csv')



runs = rbind(run1, run2, run3, run4)

data$congruency <- runs$Congruency

data$delay <- runs$Delay

data$congruency <- as.factor(data$congruency)
data$position <- runs$Position
data <- data[data$delay!=1,]

datamiss <- data[data$response == 0,]
dim(datamiss)

data <- data[data$response != 0,]

data$response = factor(data$response)
data$myEvent = factor(data$myEvent)

dim(data[data$response != data$myEvent,])

data_correct <- data[data$response == data$myEvent,]
data_incorrect <- data[data$response != data$myEvent,]

dim(data_correct)
dim(data_incorrect)

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

t.test(rt_congruent, rt_incongruent)

# Plot w congruent and incongruent
mean_plot <- ddply(data, "congruency", summarise, rt = mean(rt))
mean_plot$congruency <- c('Valid', 'Invalid')
sd_plot <- ddply(data, "congruency", summarise, std = sd(rt))
n_obs <- c(length(which(data$congruency=='0')),length(which(data$congruency=='1')))
data_plot <- data.frame(cbind(mean_plot, sd_plot[,2], n_obs, sd_plot[,2]/sqrt(n_obs)))
colnames(data_plot) <-  c('Congruency','mean','sd','n', 'se')

plot_data <- ggplot(data_plot, aes(x=Congruency, y=mean,fill=Congruency, width=.5)) + geom_bar(position ='identity' , stat='identity') + geom_errorbar(aes(ymin=mean-se,ymax=mean+se),position=position_dodge(.5),width=.01) + scale_fill_manual(values=c("grey", "grey")) + labs(y = "RT") + theme_bw() + theme(legend.position="none") + scale_y_continuous(limits=c(0,700),breaks=seq(0, 800, 50)) + theme(axis.title.x = element_blank()) + theme(text = element_text(size=20))



ggsave(file=sprintf("plot_data_%s.eps", subjname), plot= plot_data, width=6, height=6	 )


