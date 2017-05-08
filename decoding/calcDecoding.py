# Decoding functions
# Calc_MEG
# Pinheiro-Chagas - 2016

# Libraries
import sys
from GATclassifiers import (calcClassification, calcRegression)
from initDirs import dirs
import numpy as np

# cwd = os.path.dirname(os.path.abspath(__file__))
# os.chdir(cwd)

def calcDecoding(params, type, scorer):
    if type == 'class':
        # Define scorer
        print('Decoding classification')
        gat, score, diagonal = calcClassification(params['X_train'], params['y_train'], params['X_test'], params['y_test'], scorer, params['mode'], params)
    elif type == 'reg':
        # Define scorer
        print('Decoding regression')
        gat, score, diagonal = calcRegression(params['X_train'], params['y_train'], params['X_test'], params['y_test'], scorer, params['mode'], params)
    print('decoding done!')

    # Organize results
    results = ({'params': params,'gat': gat, 'score': score, 'diagonal': diagonal})
    print ('results size is: ' + str(sys.getsizeof(results))) + ' bytes'

    print('saving results')
    # Save data
    fname = dirs['result'] + 'individual_results/' + params['subject'] + '_' + params['train_set'] + '_' + params['test_set'] \
            + '_results_' + type + '_' + scorer
    np.save(fname, results)
    print('saving done')



# params, times_calc, y_predictive, y_true, score, diagonal, y_train, y_test, gat_scorer, scoreR = calc_prepDec_wTask_CR(wkdir, Condition, Subject, Type)
# y_predictive = gat.y_pred_
# y_true = gat.y_true_

# 'y_predictive': y_predictive, 'y_true': y_true,
# 'score': score, 'diagonal': diagonal, 'y_train': y_train, 'y_test': y_test}