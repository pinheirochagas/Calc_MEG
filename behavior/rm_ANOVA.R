### CLEAN WORKSPACE ###
rm(list=ls())

### PACKAGES ###
library(ez)
library(ggplot2)
library(doBy)


### INPUT DIRECTORY ###
input_dir <- "/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/behavior/"
setwd(input_dir)

### IMPORT DATA ###
beh_data <- read.csv("behavior_anova_rm.csv",header=T, sep=",", fill=T)
beh_data <- beh_data[beh_data$absDeviant>0,c(1,2,5)]
beh_data$absDeviant <- as.factor(beh_data$absDeviant)
beh_data$subject <- as.factor(beh_data$subject)

table_correctness <- read.csv("table_correctness.csv",header=T, sep=",", fill=T)
table_correctness$correctness <- as.factor(table_correctness$correctness)	
table_correctness$subject <- as.factor(table_correctness$subject)	

table_operand1 <- read.csv("table_operand1.csv",header=T, sep=",", fill=T)
table_operand2 <- read.csv("table_operand2.csv",header=T, sep=",", fill=T)
table_operation <- read.csv("table_operation.csv",header=T, sep=",", fill=T)
table_operand1_sep_op <- read.csv("table_operand1_sep_op.csv",header=T, sep=",", fill=T)
table_operand2_sep_op <- read.csv("table_operand2_sep_op.csv",header=T, sep=",", fill=T)

table_operand1_sep_op$subject <- as.factor(table_operand1_sep_op$subject)
table_operand1_sep_op$operand1 <- as.factor(table_operand1_sep_op$operand1)
table_operand1_sep_op$operation <- as.factor(table_operand1_sep_op$operation)

table_operand2_sep_op$subject <- as.factor(table_operand2_sep_op$subject)
table_operand2_sep_op$operand2 <- as.factor(table_operand2_sep_op$operand2)
table_operand2_sep_op$operation <- as.factor(table_operand2_sep_op$operation)

table_operation$subject <- as.factor(table_operation$subject)
table_operation$operation <- as.factor(table_operation$operation)


beh_data[1:12,]

### Run repeated measures ANOVA
ANOVA_deviant <- ezANOVA(data = beh_data, dv = .(RT), wid = .(subject),  within = .(absDeviant), type = 3, detailed = TRUE)

ANOVA_correctness <- ezANOVA(data = table_correctness, dv = .(RT), wid = .(subject),  within = .(correctness), type = 3, detailed = TRUE)
summaryBy

summaryBy(RT~correctness, data=table_correctness, FUN=c(mean,var), na.rm=TRUE, use="pair")  



### Problem-size effect
fit <- summary(lm(RT ~ operand2, data= table_operand2))
fit <- summary(lm(RT ~ operand1, data= table_operand1))

# Anova got significant for op2....
ANOVA_operand1 <- ezANOVA(data = table_operand1_sep_op, dv = .(RT), wid = .(subject),  within = .(operand1,operation), type = 3, detailed = TRUE)

ANOVA_operand2 <- ezANOVA(data = table_operand2_sep_op, dv = .(RT), wid = .(subject),  within = .(operand2,operation), type = 3, detailed = TRUE)

ANOVA_operation <- ezANOVA(data = table_operation, dv = .(RT), wid = .(subject),  within = .(operation), type = 3, detailed = TRUE)

# Basic box plot
p <- ggplot(table_correctness, aes(x=operand2, y=RT)) + geom_boxplot()
p


### Decoding 
table_op1_op2_0_400 <- read.csv("table_op1_op2_0-400.csv",header=T, sep=",", fill=T)
table_op1_op2_0_400$operands <- as.factor(table_op1_op2_0_400$operands)
table_op1_op2_0_400$subjects <- as.factor(table_op1_op2_0_400$subjects)

table_op1_op2_400_800 <- read.csv("table_op1_op2_400-800.csv",header=T, sep=",", fill=T)
table_op1_op2_400_800$operands <- as.factor(table_op1_op2_400_800$operands)
table_op1_op2_400_800$subjects <- as.factor(table_op1_op2_400_800$subjects)

table_op1_op2123_0_400 <- read.csv("table_op1_op2123_0-400.csv",header=T, sep=",", fill=T)
table_op1_op2123_0_400$operands <- as.factor(table_op1_op2123_0_400$operands)
table_op1_op2123_0_400$subjects <- as.factor(table_op1_op2123_0_400$subjects)

table_op1_op2123_400_800 <- read.csv("table_op1_op2123_400-800.csv",header=T, sep=",", fill=T)
table_op1_op2123_400_800$operands <- as.factor(table_op1_op2123_400_800$operands)
table_op1_op2123_400_800$subjects <- as.factor(table_op1_op2123_400_800$subjects)




ANOVA_op1_op2 <- ezANOVA(data = table_op1_op2123_0_400, dv = .(score), wid = .(subjects),  within = .(operands), type = 3, detailed = TRUE)

summaryBy(score~operands, data=table_op1_op2_0_400, FUN=c(mean,var), na.rm=TRUE, use="pair")  




ANOVA_dev <- summary(aov(RT ~ absDeviant + Error(subject/(absDeviant)), data= deviant))

ANOVA_ns_s <- summary(aov(pc_chos ~ rank * trial + Error(subj/(rank+trial)), data=ns_s))

test <- aov(pc_chos ~ rank * trial, data=ns_a)

ANOVA_deviant <- ezANOVA(data = deviant, dv = .(RT), wid = .(subject),  within = .(absDeviant), type = 3, detailed = TRUE)

summary(attitudeModel)


summary(test)

Anova(test, type='III')

summary(ANOVA_ns_a)

#ANOVA_ns_a <- summary(aov(pc_chos ~ rank * trial * Age_years + Error(subj/(rank+trial)), data=ns_a))

summary(ANOVA_ns_a)

par(mfrow = c(1,2))
interaction.plot(ns_a$rank, ns_a$trial, ns_a$pc_chos, ylim=c(0,.4))
interaction.plot(ns_s$rank, ns_s$trial, ns_s$pc_chos, ylim=c(0,.4))

ns_a_s_8 <- subset(ns_a_s, ns_a_s$Age_years == 8)
ns_a_8 <- ns_a_s_8[ns_a_s_8$operation==0,] # addition
ns_s_8 <- ns_a_s_8[ns_a_s_8$operation==1,] # addition

par(mfrow = c(1,2))
interaction.plot(ns_a_8$rank, ns_a_8$trial, ns_a_8$pc_chos, ylim=c(0,.4))
interaction.plot(ns_s_8$rank, ns_s_8$trial, ns_s_8$pc_chos, ylim=c(0,.4))

ns_a_s_9 <- subset(ns_a_s, ns_a_s$Age_years == 9)
ns_a_9 <- ns_a_s_9[ns_a_s_9$operation==0,] # addition
ns_s_9 <- ns_a_s_9[ns_a_s_9$operation==1,] # addition

par(mfrow = c(1,2))
interaction.plot(ns_a_9$rank, ns_a_9$trial, ns_a_9$pc_chos, ylim=c(0,.4))
interaction.plot(ns_s_9$rank, ns_s_9$trial, ns_s_9$pc_chos, ylim=c(0,.4))

ns_a_s_10 <- subset(ns_a_s, ns_a_s$Age_years == 10)
ns_a_10 <- ns_a_s_10[ns_a_s_10$operation==0,] # addition
ns_s_10 <- ns_a_s_10[ns_a_s_10$operation==1,] # addition

par(mfrow = c(1,2))
interaction.plot(ns_a_10$rank, ns_a_10$trial, ns_a_10$pc_chos, ylim=c(0,.4))
interaction.plot(ns_s_10$rank, ns_s_10$trial, ns_s_10$pc_chos, ylim=c(0,.4))

ns_a_s_11 <- subset(ns_a_s, ns_a_s$Age_years == 11)
ns_a_11 <- ns_a_s_11[ns_a_s_11$operation==0,] # addition
ns_s_11 <- ns_a_s_11[ns_a_s_11$operation==1,] # addition

par(mfrow = c(1,2))
interaction.plot(ns_a_11$rank, ns_a_11$trial, ns_a_11$pc_chos, ylim=c(0,.4))
interaction.plot(ns_s_11$rank, ns_s_11$trial, ns_s_11$pc_chos, ylim=c(0,.4))

ns_a_s_12 <- subset(ns_a_s, ns_a_s$Age_years == 12)
ns_a_12 <- ns_a_s_12[ns_a_s_12$operation==0,] # addition
ns_s_12 <- ns_a_s_12[ns_a_s_12$operation==1,] # addition

par(mfrow = c(1,2))
interaction.plot(ns_a_12$rank, ns_a_12$trial, ns_a_12$pc_chos, ylim=c(0,.5))
interaction.plot(ns_s_12$rank, ns_s_12$trial, ns_s_12$pc_chos, ylim=c(0,.5))

cor.test(summary_ANS_c$NC_add_cv_mean, summary_ANS_c$OM_e)
cor.test(summary_ANS_c$NC_sub_cv_mean, summary_ANS_c$OM_e)
cor.test(summary_ANS_c$w, summary_ANS_c$OM_e)

ns_a_s$Age_years <- rep(summary_ANS_c$Age_years, each=20)
ns_a_s$Age_years <- as.factor(ns_a_s$Age_years)

summary_ANS_c$Age_years <- as.factor(summary_ANS_c$Age_years)

# Development of OM
pdf("development_OM_c.pdf", height=8, width=15)
boxplot(summary_ANS_c$OM_e ~ summary_ANS_c$Age_years, horizontal=T, outline=F, xlim=c(0.5, 5.5), ylim=c(-.3, .3), main='', cex.main=1.5, xlab='Operational Momentum (Addition - Subtraction)', ylab='Age', cex.axis=1.5, cex.lab=1.5, cex=2, pch=16)
abline(0,1000000, lty='dashed', col="Blue", lwd=2)
dev.off()

om.age.ANOVA <- aov(summary_ANS_c$OM_e ~ summary_ANS_c$Age_years)

TukeyHSD(om.age.ANOVA)

c_OM.reg.age <- lm(summary_ANS_c$OM_e ~ summary_ANS_c$Age_months)
lm.beta(c_OM.reg.age)
plot(summary_ANS_c$OM_e ~ summary_ANS_c$Age_months)
abline(c_OM.reg.age)

c_NCadd.reg.age <- lm(summary_ANS_c$NC_add_cv_mean ~ summary_ANS_c$Age_months)
lm.beta(c_NCadd.reg.age)
plot(summary_ANS_c$NC_add_cv_mean ~ summary_ANS_c$Age_months)
abline(c_NCadd.reg.age)

c_NCsub.reg.age <- lm(summary_ANS_c$NC_sub_cv_mean ~ summary_ANS_c$Age_months)
lm.beta(c_NCsub.reg.age)
plot(summary_ANS_c$NC_add_cv_mean ~ summary_ANS_c$Age_months)
abline(c_NCsub.reg.age)
detach()

# Nonsymbolic Addition
	add_numbers <- c(10,16,26,40)
		# Control
		attach(summary_ANS_c)
	# Mean response
	add_mean_mean_c <- c(mean(NC_add_mean_10),mean(NC_add_mean_16),mean(NC_add_mean_26),mean(NC_add_mean_40))
	# SD response
	add_sd_mean_c <- c(mean(NC_add_sd_10),mean(NC_add_sd_16),mean(NC_add_sd_26),mean(NC_add_sd_40))
	# Mean cv
	add_cv_mean_c <- c(mean(NC_add_cv_10),mean(NC_add_cv_16),mean(NC_add_cv_26),mean(NC_add_cv_40))
		# MD
		attach(summary_ANS_md)
	# Mean response
	add_mean_mean_md <- c(mean(NC_add_mean_10),mean(NC_add_mean_16),mean(NC_add_mean_26),mean(NC_add_mean_40))
	# SD response
	add_sd_mean_md <- c(mean(NC_add_sd_10),mean(NC_add_sd_16),mean(NC_add_sd_26),mean(NC_add_sd_40))
	# Mean cv
	add_cv_mean_md <- c(mean(NC_add_cv_10),mean(NC_add_cv_16),mean(NC_add_cv_26),mean(NC_add_cv_40))
	
	# Nonsymbolic subtraction
	sub_numbers <- c(10,16,26,40)
		# Control
		attach(summary_ANS_c)
	# Mean response
	sub_mean_mean_c <- c(mean(NC_sub_mean_10),mean(NC_sub_mean_16),mean(NC_sub_mean_26),mean(NC_sub_mean_40))
	# SD response
	sub_sd_mean_c <- c(mean(NC_sub_sd_10),mean(NC_sub_sd_16),mean(NC_sub_sd_26),mean(NC_sub_sd_40))
	# Mean cv
	sub_cv_mean_c <- c(mean(NC_sub_cv_10),mean(NC_sub_cv_16),mean(NC_sub_cv_26),mean(NC_sub_cv_40))
		# MD
		attach(summary_ANS_md)
	# Mean response
	sub_mean_mean_md <- c(mean(NC_sub_mean_10),mean(NC_sub_mean_16),mean(NC_sub_mean_26),mean(NC_sub_mean_40))
	# SD response
	sub_sd_mean_md <- c(mean(NC_sub_sd_10),mean(NC_sub_sd_16),mean(NC_sub_sd_26),mean(NC_sub_sd_40))
	# Mean cv
	sub_cv_mean_md <- c(mean(NC_sub_cv_10),mean(NC_sub_cv_16),mean(NC_sub_cv_26),mean(NC_sub_cv_40))

detach()

	# Nonsymbolic addition and subtraction
pdf("nc_add_sub_c.pdf", height=7, width=8)
layout(matrix(c(1,0,2)),heights=c(.95,0,.3),respect=T)
par(mar=c(5,5,3,5))
		# Mean and SD
plot(add_numbers, add_mean_mean_c, ylim=c(0,40),type='o', pch=16, cex=2.5, col='dodgerblue3', xlab='',ylab='Chosen numbers', main='Nonsymbolic calculation',lwd=3, cex.lab=2, cex.main=2)
points(sub_numbers, sub_mean_mean_c, type='o', pch=16, cex=2.5, col='forestgreen',lwd=3)
points(add_numbers, add_sd_mean_c, type='o', pch=16, cex=2.5, col='dodgerblue3',lwd=3)
points(sub_numbers, sub_sd_mean_c, type='o', pch=16, cex=2.5, col='forestgreen',lwd=3)
mtext("SD",side=4, line=3)
axis(4, yaxp=c(5, 15, 2),cex.lab=2, cex.axis=1.5)
legend(10, 40, c("Addition", "Subtraction"), col = c("dodgerblue3","forestgreen"),text.col = "black",lty=1,pch=16, merge = F, bg = "white")
		# cv
plot(add_numbers, add_cv_mean_c, ylim=c(.2,.5),type='o', pch=16, cex=2.5, col='dodgerblue3', xlab='Correct outcomes',ylab='CV', main='',lwd=3, cex.lab=1.5, cex.axis=1.5)
points(sub_numbers, sub_cv_mean_c, type='o', pch=16, cex=2.5, col="forestgreen",lwd=3)
dev.off()

	# Nonsymbolic addition
lm.add.cv.cnumber.c <- lm(add_cv_mean_c ~ add_numbers)
summary(lm.add.cv.cnumber.c)
lm.beta(lm.add.cv.cnumber.c)
	# Nonsymbolic subtraction
lm.sub.cv.cnumber.c <- lm(sub_cv_mean_c ~ sub_numbers)
summary(lm.sub.cv.cnumber.c)
lm.beta(lm.sub.cv.cnumber.c)


om.age.mean <- by(summary_ANS_c$OM_e, summary_ANS_c$Age_years, mean)
om.age.sd <- by(summary_ANS_c$OM_e, summary_ANS_c$Age_years, sd)
om.eb.up <- om.age.mean+om.age.sd/sqrt(dim(summary_ANS_c)[1])
om.eb.low <- om.age.mean-om.age.sd/sqrt(dim(summary_ANS_c)[1])

om.age <- cbind(om.age.mean, om.eb.up, om.eb.low)

pdf("om.barplot.pdf", height=5, width=5)
om.barplot <- barplot(om.age[,1], col=c('gray60','gray50', 'gray40', 'gray30', 'gray20'),ylim=c(0,.15), ylab='Addition - Subtraction', xlab='Age in years', main='Operational momentum effect' )
errbar(om.barplot[,1], om.age[,1], om.eb.up, om.age[,1], add=T, pch='', cap=0)
dev.off()

cor(summary_ANS_c$OM_e, summary_ANS_c$est_cv)

pdf("NC_cv_OM_age_c.pdf",height=7, width=7)
cex_c = 1
size = 1.4
par(mar=c(5,4,4,5)+1)
plot(c(summary_ANS_c$Age_months,summary_ANS_md$Age_months),c(summary_ANS_c$NC_add_cv_mean, summary_ANS_md$NC_add_cv_mean),xlab="Age",ylab="Nonsymbolic calculation cv",type="n", cex.axis=size, cex.lab=size, xlim=c(90, 160), ylim=c(-0.2,0.65), main='Nonsymbolic calculation accuracy and the OM effect') 
points(summary_ANS_c$Age_months,summary_ANS_c$NC_add_cv_mean,col="blue", pch=16, cex=cex_c)
points(summary_ANS_c$Age_months,summary_ANS_c$NC_sub_cv_mean,col="green4", pch=16, cex=cex_c)
points(summary_ANS_c$Age_months,summary_ANS_c$OM_e,col="gray70", pch=16, cex=cex_c)
abline(lm(summary_ANS_c$NC_add_cv_mean~summary_ANS_c$Age_months), col="blue2", lwd=2)
abline(lm(summary_ANS_c$NC_sub_cv_mean~summary_ANS_c$Age_months), col="green4", lwd=2)
abline(lm(summary_ANS_c$OM_e~summary_ANS_c$Age_months), col="gray70", lwd=2)
axis(4, c(seq(-.2, .6, 0.2)))
mtext("Operational momentum effect",side=4, line=3)
legend(141.5, 0.65, c("Add cv", "Sub cv", "OM"), col = c("blue2","green4", "gray70"),text.col = "black",lty=1,pch=16, merge = F, bg = "white")
dev.off()

	# Nonsymbolic addition
lm.add.age.c <- lm(summary_ANS_c$NC_add_cv_mean ~ summary_ANS_c$Age_months)
summary(lm.add.age.c)
lm.beta(lm.add.age.c)

	# Nonsymbolic subtraction
lm.sub.age.c <- lm(summary_ANS_c$NC_sub_cv_mean ~ summary_ANS_c$Age_months)
summary(lm.sub.age.c)
lm.beta(lm.sub.age.c)


	# Operational momentum effect
lm.OM.age.c <- lm(summary_ANS_c$OM_e ~ summary_ANS_c$Age_months)
summary(lm.OM.age.c)
lm.beta(lm.OM.age.c)




dim(summary_ANS_c)

# OM development MD

om.age.mean <- by(summary_ANS_md$OM_e, summary_ANS_md$Age_years, mean)
om.age.sd <- by(summary_ANS_md$OM_e, summary_ANS_md$Age_years, sd)
om.eb.up <- om.age.mean+om.age.sd/sqrt(dim(summary_ANS_md)[1])
om.eb.low <- om.age.mean-om.age.sd/sqrt(dim(summary_ANS_md)[1])

om.age <- cbind(om.age.mean, om.eb.up, om.eb.low)

pdf("om_md_age.pdf", height=5, width=5)
om.barplot <- barplot(om.age[,1], col=c('gray60','gray50', 'gray40', 'gray30', 'gray20'),ylim=c(-.15,.15), ylab='Addition - Subtraction', xlab='Age in years', main='Operational momentum effect' )
errbar(om.barplot[,1], om.age[,1], om.eb.up, om.age[,1], add=T, pch='', cap=0)
dev.off()


# OM development Controls

om.age.mean <- by(summary_ANS_c$OM_e, summary_ANS_c$Age_years, mean)
om.age.sd <- by(summary_ANS_c$OM_e, summary_ANS_c$Age_years, sd)
om.eb.up <- om.age.mean+om.age.sd/sqrt(dim(summary_ANS_c)[1])
om.eb.low <- om.age.mean-om.age.sd/sqrt(dim(summary_ANS_c)[1])

om.age <- cbind(om.age.mean, om.eb.up, om.eb.low)

pdf("om_c_age.pdf", height=5, width=5)
om.barplot <- barplot(om.age[,1], col=c('gray60','gray50', 'gray40', 'gray30', 'gray20'),ylim=c(0,.15), ylab='Addition - Subtraction', xlab='Age in years', main='Operational momentum effect' )
errbar(om.barplot[,1], om.age[,1], om.eb.up, om.age[,1], add=T, pch='', cap=0)
dev.off()



# OM development Additions

om.age.mean <- by(summary_ANS_c$OM_a, summary_ANS_c$Age_years, mean)
om.age.sd <- by(summary_ANS_c$OM_a, summary_ANS_c$Age_years, sd)
om.eb.up <- om.age.mean+om.age.sd/sqrt(dim(summary_ANS_c)[1])
om.eb.low <- om.age.mean-om.age.sd/sqrt(dim(summary_ANS_c)[1])

om.age <- cbind(om.age.mean, om.eb.up, om.eb.low)

pdf("om_c_age_addition.pdf", height=5, width=5)
om.barplot <- barplot(om.age[,1], col=c('gray60','gray50', 'gray40', 'gray30', 'gray20'),ylim=c(-.1,.1), ylab='Addition', xlab='Age in years', main='Operational momentum effect' )
errbar(om.barplot[,1], om.age[,1], om.eb.up, om.age[,1], add=T, pch='', cap=0)
dev.off()


# OM development Additions

om.age.mean <- by(summary_ANS_c$OM_s, summary_ANS_c$Age_years, mean)
om.age.sd <- by(summary_ANS_c$OM_s, summary_ANS_c$Age_years, sd)
om.eb.up <- om.age.mean+om.age.sd/sqrt(dim(summary_ANS_c)[1])
om.eb.low <- om.age.mean-om.age.sd/sqrt(dim(summary_ANS_c)[1])

om.age <- cbind(om.age.mean, om.eb.up, om.eb.low)

pdf("om_c_age_subtraction.pdf", height=5, width=5)
om.barplot <- barplot(om.age[,1], col=c('gray60','gray50', 'gray40', 'gray30', 'gray20'),ylim=c(-.1,.1), ylab='Subtraction', xlab='Age in years', main='Operational momentum effect' )
errbar(om.barplot[,1], om.age[,1], om.eb.up, om.age[,1], add=T, pch='', cap=0)
dev.off()


summary_ANS_c$Age_years <- as.factor(summary_ANS_c$Age_years)



# Groups
om.group.mean <- by(summary_ANS$OM_e, summary_ANS$Groups_MG, mean)
om.group.sd <- by(summary_ANS$OM_e, summary_ANS$Groups_MG, sd)
om.eb.up <- om.group.mean+om.group.sd/sqrt(dim(summary_ANS)[1])
om.eb.low <- om.group.mean-om.group.sd/sqrt(dim(summary_ANS)[1])

om.groups <- cbind(om.group.mean, om.eb.up, om.eb.low)


om.barplot <- barplot(om.groups [,1], col=c('gray60','gray50', 'gray40', 'gray30', 'gray20'),ylim=c(0,.15), ylab='Addition - Subtraction', xlab='Age in years', main='Operational momentum effect' )
errbar(om.barplot[,1], om.groups[,1], om.eb.up, om.age[,1], add=T, pch='', cap=0)


# Control
om.group.mean_c_add <- mean(summary_ANS_c$OM_a)
om.group.sd_c_add <- sd(summary_ANS_c$OM_a)
om.eb.up_c_add <- om.group.mean_c_add+om.group.sd_c_add/sqrt(dim(summary_ANS_c)[1])
om.eb.low_c_add <- om.group.mean_c_add-om.group.sd_c_add/sqrt(dim(summary_ANS_c)[1])

om.group.mean_c_sub <- mean(summary_ANS_c$OM_s)
om.group.sd_c_sub <- sd(summary_ANS_c$OM_s)
om.eb.up_c_sub <- om.group.mean_c_sub+om.group.sd_c_sub/sqrt(dim(summary_ANS_c)[1])
om.eb.low_c_sub <- om.group.mean_c_sub-om.group.sd_c_sub/sqrt(dim(summary_ANS_c)[1])

om.groups_c_add <- cbind(om.group.mean_c_add, om.eb.up_c_add, om.eb.low_c_add)
om.groups_c_sub <- cbind(om.group.mean_c_sub, om.eb.up_c_sub, om.eb.low_c_sub)
om.groups_c_add_sub <- rbind(om.groups_c_add, om.groups_c_sub)

pdf("om_c.pdf", height=5, width=5)
om.barplot <- barplot(om.groups_c_add_sub[,1], col=c('gray60','gray50', 'gray40', 'gray30', 'gray20'),ylim=c(-.1,.1), ylab='Addition - Subtraction', xlab='Age in years', main='OM Controls' )
errbar(om.barplot[,1], om.groups_c_add_sub[,1], om.groups_c_add_sub[,3], om.groups_c_add_sub[,1], add=T, pch='', cap=0)
dev.off()



## MD

om.group.mean_md_add <- mean(summary_ANS_md$OM_a)
om.group.sd_md_add <- sd(summary_ANS_md$OM_a)
om.eb.up_md_add <- om.group.mean_md_add+om.group.sd_md_add/sqrt(dim(summary_ANS_md)[1])
om.eb.low_md_add <- om.group.mean_md_add-om.group.sd_md_add/sqrt(dim(summary_ANS_md)[1])

om.group.mean_md_sub <- mean(summary_ANS_md$OM_s)
om.group.sd_md_sub <- sd(summary_ANS_md$OM_s)
om.eb.up_md_sub <- om.group.mean_md_sub+om.group.sd_md_sub/sqrt(dim(summary_ANS_md)[1])
om.eb.low_md_sub <- om.group.mean_md_sub-om.group.sd_md_sub/sqrt(dim(summary_ANS_md)[1])

om.groups_md_add <- cbind(om.group.mean_md_add, om.eb.up_md_add, om.eb.low_md_add)
om.groups_md_sub <- cbind(om.group.mean_md_sub, om.eb.up_md_sub, om.eb.low_md_sub)
om.groups_md_add_sub <- rbind(om.groups_md_add, om.groups_md_sub)

pdf("om_md.pdf", height=5, width=5)
om.barplot <- barplot(om.groups_md_add_sub[,1], col=c('gray60','gray50', 'gray40', 'gray30', 'gray20'),ylim=c(-.1,.1), ylab='Addition - Subtraction', xlab='Age in years', main='OM MDs' )
errbar(om.barplot[,1], om.groups_md_add_sub[,1], om.groups_md_add_sub[,3], om.groups_md_add_sub[,1], add=T, pch='', cap=0)
dev.off()




