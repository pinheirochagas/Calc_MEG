# Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
import numpy as np
import matplotlib.pyplot as plt
import combineSubsDecoding
import plotDecodingExplore
reload(plotDecodingExplore)
from combineSubsDecoding import combineSubsDecoding
from plotDecodingExplore import plotDecodingExplore
from initDirs import dirs
import scipy.io

### Combine results and plot
#List of parameters
subjects = ['s02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']
#subjects = ['s02', 's03']

baselinecorr = 'nobaseline'
dec_method = 'class'  # 'reg' or 'class'
dec_scorer = 'accuracy'  # or 'accuracy' kendall_score
gatordiag = 'gat'
sfreq = 125

# conditions = [['op1', 'op1'], ['resultlock_op1', 'resultlock_op1'], ['resultlock_op2', 'resultlock_op2'], ['resultlock_pres', 'resultlock_pres'],
#               ['resplock_op1', 'resplock_op1'],['resplock_op2', 'resplock_op2'],['resplock_pres', 'resplock_pres']]

#conditions = [['resultlock_deviant', 'resultlock_deviant']]

conditions = [['resplock_respside', 'resplock_respside'], ['resplock_choice', 'resplock_choice']]


for i in range(len(conditions)):
    condition = conditions[i]
    res = combineSubsDecoding(subjects, baselinecorr, dec_method, dec_scorer, gatordiag, [condition], sfreq)
    plotDecodingExplore(res)
    # Prepare results
    fname = dirs['gp_result'] + [condition][0][0] + '_' + [condition][0][1] + '/' + [condition][0][0] + '_' + [condition][0][1] + '_' + dec_method + '_' + dec_scorer + '_' + 'results'
    np.save(fname, res)
    fname_mat = fname + '.mat'
    scipy.io.savemat(fname_mat, res)
    plt.close("all")



## Missing

# ['resultlock_addsub', 'resultlock_addsub']
# ['resplock_absdeviant', 'resplock_absdeviant']
# ['resplock_cres', 'resplock_cres']
# ['resplock_addsub', 'resplock_addsub']



## Done
# ['addsub', 'addsub']
# conditions = [['resplock_respside', 'resplock_respside']]

## To complete
# addsub
# op2 reg




# conditions = [['op2', 'op2'], ['cres', 'cres'], ['resultlock_op1', 'resultlock_op1'],
#               ['resultlock_op2', 'resultlock_op2'], ['resultlock_cres', 'resultlock_cres'],
#               ['resultlock_pres', 'resultlock_pres'], ['resultlock_absdeviant', 'resultlock_absdeviant'], ['resultlock_deviant', 'resultlock_deviant'],
#               ['resplock_respside', 'resplock_respside'], ['resplock_choice', 'resplock_choice'],
#               ['resplock_deviant', 'resplock_deviant'], ['resplock_pres', 'resplock_pres'],
#               ['resplock_op2', 'resplock_op2'], ['resplock_op1', 'resplock_op1']]




#######################################################################################################################

