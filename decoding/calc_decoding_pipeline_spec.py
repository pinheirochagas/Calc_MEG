# Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
from calcDecoding import calcDecodingAlltimes
import numpy as np
from classifyGeneral import classifyGeneral
import pandas as pd
from prepDataDecTFA import prepDataDecTFA
from initDirs import dirs
import os
import matplotlib.pyplot as plt
import seaborn as sns


# Subjects
subjects = ['s02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']
#subjects = ['s02', 's03']

# Basic parameters
conditions = [['cres_riemann', 'cres_riemann']]
baselinecorr = 'nobaseline'
dec_method = 'classGeneral' # class reg classGeneral
dec_scorer = 'accuracy' # accuracy or kendall_score
gatordiag = 'diagonal'
decimate = 2

results = pd.DataFrame()
for s, subject in enumerate(subjects):
    params = prepDataDecoding(dirs, conditions[0][0], conditions[0][1], subject, baselinecorr, decimate)
    result = classifyGeneral(params['X_train']._data, params['y_train'], params)     # or calcDecoding(params, dec_method, dec_scorer, gatordiag)
    results = results.append(result)

### Save
save_dir = dirs['result'] + 'individual_results/' + params['train_set'] + '_' + params['test_set'] + '/'
if not os.path.exists(save_dir):
    os.makedirs(save_dir)

fname = save_dir + '_' + params['train_set'] + '_' + params['test_set'] + '_results_XdawnCov_SimpleSVM_with_offsets.csv'
results.to_csv(fname)

### Plot
#sns.set_style("whitegrid")
sns.boxplot(data=results, color=[.7, .7, .7])
sns.swarmplot(data=results, size=7)
plt.savefig(save_dir + 'results_XdawnCov_ERPCov_HankelCov_SimpleSVM_1600ms.png')












########## Time frequency
# results = pd.DataFrame(index=range(1, 1), columns={'Accuracy'})
# conditions = [['op2_freq_riemann', 'op2_freq_riemann']]
# for s, subject in enumerate(subjects):
#     X, y, params = prepDataDecTFA(dirs, conditions[0][0], conditions[0][1], subject)
#     result = classifyGeneral(X, y, params)
#     results.loc[s] = result['Accuracy'][0]

