# Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
from calcDecoding import calcDecodingAlltimes
import numpy as np

# Subjects
subjects = ['s01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
            's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']

subjects = ['s03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
            's11', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's22']

subject = 's03'

##
conditions = [['presTlockCres', 'cres']]
baselinecorr = 'no'
dec_method = 'class'
dec_scorer = 'accuracy'
gatordiag = 'gat'
decimate = 50

params = prepDataDecoding(dirs, conditions[0][0], conditions[0][1], subject, baselinecorr, decimate)
calcDecoding(params, dec_method, dec_scorer, gatordiag)





# Load results
import sys
import numpy as np
import matplotlib.pyplot as plt
import scipy.io as sio
from scipy import stats
from initDirs import dirs
from jr.plot import pretty_gat, pretty_decod
import mne
from mne.decoding import GeneralizationAcrossTime


#Combine results from all conditions
all_scores = []
all_diagonals = []

for c, cond in enumerate(conditions):
    for s, subject in enumerate(subjects):
        print('loading subject ' + subject)
        fname = dirs['result'] + 'individual_results/' + subject + '_' + cond[0] + '_' + cond[1] + '_results_class_accuracy_diagonal_nobaseline_correct.npy'
        #fname = dirs['result'] + 'individual_results/' + subject + '_' + cond[0] + '_' + cond[1] + '_results_class_accuracy_diagonal_nobaseline_correct.npy'
        results = np.load(fname)
        # Convert to list
        results = results.tolist()
        all_scores.append(results['score'])
        all_diagonals.append(results['diagonal'])
score = results['score']
diagonal = results['diagonal']
#time_calc = results['params']['times_calc']
#params = results['params']
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



pretty_gat(group_scores[0, :, :], chance=.25)