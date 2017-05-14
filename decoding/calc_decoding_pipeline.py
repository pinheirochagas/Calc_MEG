# Libraries
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
import numpy as np

# Subjects
subjects = ['s01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
            's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']

subjects = ['s02','s03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
            's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']

for s, subject in enumerate(subjects):
    params = prepDataDecoding(dirs, 'cres', 'cres', subject, 'baseline_nocorrect')
    calcDecoding(params, 'class', 'accuracy', 'diagonal')

for s, subject in enumerate(subjects):
    params = prepDataDecoding(dirs, 'op1', 'op1', subject, 'baseline_nocorrect')
    calcDecoding(params, 'class', 'accuracy', 'diagonal')

for s, subject in enumerate(subjects):
    params = prepDataDecoding(dirs, 'op2', 'op2', subject, 'baseline_nocorrect')
    calcDecoding(params, 'class', 'accuracy', 'diagonal')

for s, subject in enumerate(subjects):
    params = prepDataDecoding(dirs, 'addsub', 'addsub', subject, 'baseline_nocorrect')
    calcDecoding(params, 'class', 'accuracy', 'diagonal')

for s, subject in enumerate(subjects):
    params = prepDataDecoding(dirs, 'presTlock', 'presTlock', subject, 'baseline_nocorrect')
    calcDecoding(params, 'class', 'accuracy', 'diagonal')




#######################################################################################################################
# Load results
import sys
import numpy as np
import matplotlib.pyplot as plt
import scipy.io as sio
from scipy import stats
from initDirs import dirs

import mne
from mne.decoding import GeneralizationAcrossTime

sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')

from jr.plot import pretty_gat, pretty_decod

subjects = ['s02', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
            's11', 's12', 's14', 's15', 's16', 's17', 's18','s19', 's21', 's22']

subjects = ['s02']

conditions = [['cres', 'cres']]

#Combine results from all conditions
all_scores = []
all_diagonals = []

for c, cond in enumerate(conditions):
    for s, subject in enumerate(subjects):
        print('loading subject ' + subject)
        fname = dirs['result'] + 'individual_results/' + subject + '_' + cond[0] + '_' + cond[1] + '_results_class_accuracy_diagonal_baseline_nocorrect.npy'
        results = np.load(fname)
        # Convert to list
        results = results.tolist()
        all_scores.append(results['score'])
        all_diagonals.append(results['diagonal'])
score = results['score']
diagonal = results['diagonal']
time_calc = results['params']['times_calc']
params = results['params']
all_scores = np.array(all_scores) #shape: subjects*n_cond, training_times, testing_times
all_diagonals = np.array(all_diagonals)




#Average data
#Reshape
all_scores = np.reshape(all_scores, (len(conditions), len(subjects), score.shape[0], score.shape[1])) #n_cond, n_subj, training_times, testing_times
all_diagonals = np.reshape(all_diagonals, (len(conditions), len(subjects), diagonal.shape[0]))

group_scores = np.zeros((len(conditions), all_scores.shape[2], all_scores.shape[3]))
sem_group_scores = np.zeros((len(conditions), all_scores.shape[2], all_scores.shape[3]))
group_diagonal = np.zeros((len(conditions), all_diagonals.shape[2]))
sem_group_diagonal = np.zeros((len(conditions), all_diagonals.shape[2]))


for c, cond in enumerate(conditions):
    group_scores[c, :, :] = np.mean(all_scores[c, :, :, :], 0)
    sem_group_scores[c, :, :] = stats.sem(all_scores[c, :, :, :], 0)

    group_diagonal[c, :] = np.mean(all_diagonals[c, :, :], 0)
    sem_group_diagonal[c, :] = stats.sem(all_diagonals[c, :, :], 0)


for s, subject in enumerate(subjects):
    plt.figure(figsize=(15, 5))
    pretty_decod(all_scores[0,s,:,0], chance=.25)
    plt.axvline(.8, color = 'g') #mark stimulus onset
    plt.axvline(1.6, color = 'g') #mark stimulus onset
    plt.axvline(2.4, color = 'g') #mark stimulus onset
    plt.axvline(3.2, color = 'g') #mark stimulus onset
    plt.ylim(.1,.50)
    plt.savefig(dirs['result'] + 'individual_results/' + subject + 'cres.png')

plt.close('all')

#params = prepDataDecoding(dirs, 'cres', 'cres', 's02', 'baseline_correct')



params = prepDataDecoding(dirs, 'cres', 'cres', 's08', 'baseline_correct')
calcDecoding(params, 'class', 'accuracy', 'diagonal')





results = np.load('/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/decoding/individual_results/s08_cres_cres_results_class_accuracy.npy')
results = results.tolist()


from jr.plot import pretty_gat, pretty_decod
import matplotlib.pyplot as plt


scores = results['score']


plt.subplot(3, 1, 1)
pretty_decod(scores, chance=.25)
plt.subplot(3, 1, 2)
pretty_gat(scores, chance=.25)
plt.subplot(3, 1, 3)
plt.plot(diag)



# Define conditions
conds = ['addsub', 'addsub']

# Run classification
calc_dec_wTask_CR(root_dir,['addsub', 'addsub'],'s01','class')



##############################################################






