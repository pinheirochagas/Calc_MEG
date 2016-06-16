#Purpose: Configuration file to be imported at the beginning of the analyses
# Calc_MEG
# Pinheiro-Chagas - 2016
# Adapted from Darinka Treubutschek

##############################################################################################
#Paths
wkdir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014'
job_path = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding/somaWF/jobs'
data_path = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/mat'
result_path = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/decoding'
script_path = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding'

#############################################################################################
#Preprocessing
baseline = (-0.5, -0.05) #time for the baseline period
downsampling = 0 #downsampling factor (input at 250Hz)

########################################################################
#Decoding
#trainTimes = {'start': -0.2, 'stop': 4.5, 'step': 0.008, 'length': 0.008}
#testTimes = {'start': -0.2, 'stop': 4.5, 'step': 0.008, 'length': 0.008}

#trainTimes = {'start': -0.1, 'stop': 0.8, 'step': 0.012, 'length': 0.012}
#testTimes = {'start': -0.1, 'stop': 0.8, 'step': 0.012, 'length': 0.012}

trainTimes = {'start': -0.1, 'stop': 4.5}
testTimes = {'start': -0.1, 'stop': 4.5}

scorer = 'scorer_auc' #other options: 'prob_accuracy', 'scorer_angle'