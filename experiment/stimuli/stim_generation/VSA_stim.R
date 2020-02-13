library(reshape)
### CLEAN WORKSPACE ###
rm(list=ls())

subjname = 'sub5'

path = sprintf("/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/experiment/stimuli/VSA/pilot/%s", subjname)
dir.create(path)

setwd(path)

ntrials = 300
mean_trial_dur <- ((24+32+120+12)*16.777)/1000 # mean trial duration 
(mean_trial_dur*300)/60

pcinc = 0.20
pccon = 0.80

incongruent <- ntrials*pcinc
congruent <- ntrials*pccon
#ntrials_blocks <- ntrials/2 
ntrials_blocks <- ntrials

rml = 20 # rep of minimal list
rfl = ntrials_blocks%/%(rml*2) # rep of full list
rflr = ntrials_blocks%%(rml*2) # rest to be added

rfllet = ntrials_blocks%/%rml # rep of full list
rflrlet = ntrials_blocks%%rml # rest to be added

# Runs 1 and 2
#Cue <- rep(c(rep('DodgerBlue', rml), rep('Orange', rml)))
Cue <- rep(c(rep(-6, rml), rep(6, rml)))

Position <- c(rep(-6, rml*pccon), rep(6,rml*pcinc), rep(6,rml*pccon), rep(-6,rml*pcinc))
Congruency <- c(rep(0,rml*pccon), rep(1,rml*pcinc), rep(0,rml*pccon), rep(1,rml*pcinc))

Cue <- c(rep(Cue,rfl),Cue[1:rflr])
Position <- c(rep(Position,rfl), Position[1:rflr])
Congruency <- c(rep(Congruency,rfl), Congruency[1:rflr])

Letter <- c()
for(i in 1:rfllet){
#Letter[[i]] <- c(rep(c('T', 'T'),8),sample(c('T', 'T', 'T', 'T')))
 Letter[[i]] <- c(rep(c('T', 'L'),8),sample(c('T', 'T', 'L', 'L')))
}
Letter <- melt.list(Letter)
#Letter <- c(as.character(Letter$value), rep(c('T', 'T'), rflrlet/2))
 Letter <- c(as.character(Letter$value), rep(c('T', 'L'), rflrlet/2))

#Delay <- c(round(runif(ntrials_blocks*.9, 24, 48)),rep(1, ntrials_blocks -ntrials_blocks*.9))

Delay <- c(rep(24, ntrials/2))

VSA_df <- data.frame(Cue, Letter, Position,Delay, Congruency)
as.factor(VSA_df$Congruency)

#VSA_df$cong_check <- VSA_df$Cue == VSA_df$Position

VSA_shuffle <- VSA_df[sample(nrow(VSA_df)),]

# Add 3 training trials for each block
VSA_run1 <- rbind(VSA_shuffle[10:12,], VSA_shuffle[1:75,])
VSA_run2 <- rbind(VSA_shuffle[20:22,], VSA_shuffle[76:150,])
VSA_run3 <- rbind(VSA_shuffle[30:32,], VSA_shuffle[151:225,])
VSA_run4 <- rbind(VSA_shuffle[40:42,], VSA_shuffle[226:300,])


VSA_runs = rbind(VSA_run1, VSA_run2, VSA_run3, VSA_run4)


dim(VSA_run1)
dim(VSA_run2)
dim(VSA_run3)
dim(VSA_run4)

dim(VSA_shuffle[VSA_shuffle$Congruency ==0,])
dim(VSA_shuffle[VSA_shuffle$Congruency ==1,])


write.csv(VSA_run1, 'run1.csv',row.names = FALSE)
write.csv(VSA_run2, 'run2.csv',row.names = FALSE)
write.csv(VSA_run3, 'run3.csv',row.names = FALSE)
write.csv(VSA_run4, 'run4.csv',row.names = FALSE)


# Runs 3 and 4

#Position <- c(rep(6, rml*pccon), rep(-6,rml*pcinc), rep(-6,rml*pccon), rep(6,rml*pcinc))
#Position <- c(rep(Position,rfl), Position[1:rflr])

#Delay <- c(round(runif(ntrials_blocks*.9, 24, 48)),rep(1, ntrials_blocks -ntrials_blocks*.9))
#Delay <- c(rep(24, ntrials/2))

#VSA_df <- data.frame(Cue, Letter, Position,Delay, Congruency)
#as.factor(VSA_df$Congruency)

#VSA_shuffle <- VSA_df[sample(nrow(VSA_df)),]

#VSA_run3 <- VSA_shuffle[1:75,]
#VSA_run4 <- VSA_shuffle[76:150,]
#write.csv(VSA_run3, 'run3.csv',row.names = FALSE)
#write.csv(VSA_run4, 'run4.csv',row.names = FALSE)


#VSA_run1_scon <- summary(VSA_run1[VSA_run3$Congruency == 0,])
#VSA_run2_scon <- summary(VSA_run2[VSA_run3$Congruency == 0,])
#VSA_run3_scon <- summary(VSA_run3[VSA_run3$Congruency == 0,])
#VSA_run4_scon <- summary(VSA_run4[VSA_run3$Congruency == 0,])

#VSA_run1_sicon <- summary(VSA_run1[VSA_run3$Congruency == 1,])
#VSA_run2_sicon <- summary(VSA_run2[VSA_run3$Congruency == 1,])
#VSA_run3_sicon <- summary(VSA_run3[VSA_run3$Congruency == 1,])
#VSA_run4_sicon <- summary(VSA_run4[VSA_run3$Congruency == 1,])


