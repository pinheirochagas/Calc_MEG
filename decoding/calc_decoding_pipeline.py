# Import functions
import sys
sys.path.append('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts_git/Calc_MEG/decoding/')

from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
import numpy as np

# Subjects
subjects = ['s01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
            's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']

subjects = ['s03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
            's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']



#params = prepDataDecoding(dirs, 'cres', 'cres', 's02', 'baseline_correct')



params = prepDataDecoding(dirs, 'cres', 'cres', 's08', 'baseline_correct')
calcDecoding(params, 'class', 'accuracy', 'diagonal')



for s, subject in enumerate(subjects):
    params = prepDataDecoding(dirs, 'op1', 'op1', subject, 'baseline_correct')
    calcDecoding(params, 'class', 'accuracy', 'diagonal')

for s, subject in enumerate(subjects):
    params = prepDataDecoding(dirs, 'op2', 'op2', subject, 'baseline_correct')
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



