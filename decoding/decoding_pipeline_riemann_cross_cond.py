# Libraries
import sys
#sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
sys.path.append('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts_git/Calc_MEG/decoding/')

from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
from calcDecoding import calcDecodingAlltimes
import numpy as np
from classifyGeneralCrossCond import classifyGeneralCrossCond
import pandas as pd
from prepDataDecTFA import prepDataDecTFA
from initDirs import dirs
import os
import matplotlib.pyplot as plt
#import seaborn as sns


# Subjects
subjects = ['s02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']

# Basic parameters
conditions = [['addsub_riemann', 'op2_3_riemann']]  # addsub_riemann op2_riemann op1_riemann cres_riemann
baselinecorr = 'nobaseline'
dec_method = 'classifyGeneralCrossCond'  # class reg classGeneral
dec_scorer = 'accuracy'  # accuracy or kendall_score
gatordiag = 'diagonal'
decimate = 2

# Prepare dirs
save_dir_individual = dirs['result'] + 'individual_results/' + conditions[0][0] + '_' + conditions[0][1] + '/'
if not os.path.exists(save_dir_individual):
    os.makedirs(save_dir_individual)

save_dir_group = dirs['result'] + 'individual_results/' + conditions[0][0] + '_' + conditions[0][1] + '/'
if not os.path.exists(save_dir_group):
    os.makedirs(save_dir_group)

# Initialize results dataframes
results_train = pd.DataFrame()
results_test = pd.DataFrame()

for s, subject in enumerate(subjects):
    params = prepDataDecoding(dirs, conditions[0][0], conditions[0][1], subject, baselinecorr, decimate)
    result_train, result_test, preds_train, preds_test, y_train, y_test = classifyGeneralCrossCond(params['X_train']._data, params['X_test']._data, params['y_train'], params['y_test'])     # or calcDecoding(params, dec_method, dec_scorer, gatordiag)

    fname = save_dir_individual + conditions[0][0] + '_' + conditions[0][1] + '_' + subject + '_y_preds_train_ERPcov'
    np.save(fname, preds_train)
    fname = save_dir_individual + conditions[0][0] + '_' + conditions[0][1] + '_' + subject + '_y_true_train_ERPcov'
    np.save(fname, y_train)
    results_train = results_train.append(result_train)

    fname = save_dir_individual + conditions[0][0] + '_' + conditions[0][1] + '_' + subject + '_y_preds_test_ERPcov'
    np.save(fname, preds_test)
    fname = save_dir_individual + conditions[0][0] + '_' + conditions[0][1] + '_' + subject + '_y_true_test_ERPcov'
    np.save(fname, y_test)
    results_test = results_test.append(result_test)

### Save group results
fname = save_dir_group + conditions[0][0] + '_' + conditions[0][1] + '_results_train_ERPcov.csv'
results_train.to_csv(fname)
fname = save_dir_group + conditions[0][0] + '_' + conditions[0][1] + '_results_test_ERPcov.csv'
results_test.to_csv(fname)



#
# ### Plot
# #sns.set_style("whitegrid")
# sns.boxplot(data=results, color=[.7, .7, .7])
# sns.swarmplot(data=results, size=7)
# plt.savefig(save_dir + 'results_XdawnCov_ERPCov_HankelCov_SimpleSVM_1600ms.png')


########## Time frequency
# results = pd.DataFrame(index=range(1, 1), columns={'Accuracy'})
# conditions = [['op2_freq_riemann', 'op2_freq_riemann']]
# for s, subject in enumerate(subjects):
#     X, y, params = prepDataDecTFA(dirs, conditions[0][0], conditions[0][1], subject)
#     result = classifyGeneral(X, y, params)
#     results.loc[s] = result['Accuracy'][0]
