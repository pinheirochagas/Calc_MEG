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



params = prepDataDecoding(dirs, 'cres', 'cres', 's02', 'baseline_correct')

calcDecoding(params, 'class', 'class_score')


results = np.load('/Volumes/NeuroSpin4T/Calculation_Pedro_2014/results/decoding/individual_results/s02_cres_cres_results_class_scorer_auc.npy')
results = results.tolist()


from jr.plot import pretty_gat, pretty_decod

scores = results['score']
pretty_gat(scores[:,:,0])

# Define conditions
conds = ['addsub', 'addsub']

# Run classification
calc_dec_wTask_CR(root_dir,['addsub', 'addsub'],'s01','class')



