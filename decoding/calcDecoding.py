# Decoding functions
# Calc_MEG
# Pinheiro-Chagas - 2016

# Libraries
import sys
from GATclassifiers import (calcClassification, calcRegression)
from initDirs import dirs
import numpy as np
import os
#from mne.decoding import Vectorizer
#from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
#from sklearn.model_selection import cross_val_score

# cwd = os.path.dirname(os.path.abspath(__file__))
# os.chdir(cwd)

def calcDecoding(params, type, scorer, gatordiag):
    # Define firs if it' gat or only diagonal
    if gatordiag is 'diagonal':
        params['test_times'] = 'diagonal'

    if type == 'class':
        # Define scorer
        print('Decoding classification subject ' + params['subject'])
        y_pred, score, diagonal = calcClassification(params['X_train'], params['y_train'], params['X_test'], params['y_test'], scorer, params['mode'], params)
    elif type == 'reg':
        # Define scorer
        print('Decoding regression subject ' + params['subject'])
        y_pred, score, diagonal = calcRegression(params['X_train'], params['y_train'], params['X_test'], params['y_test'], scorer, params['mode'], params)
    print('decoding subject ' + params['subject'] + ' done!')

    # Organize results
    # results = ({'params': params,'y_pred': y_pred, 'score': score, 'diagonal': diagonal})
    results = ({'train_times': params['train_times'], 'test_times': params['test_times'], 'times_calc': params['times_calc'], 'y_pred': y_pred, 'score': score, 'diagonal': diagonal})
    print ('results size is: ' + str(sys.getsizeof(results))) + ' bytes'

    print('saving results')
    # Save data
    save_dir = dirs['result'] + 'individual_results/' + params['train_set'] + '_' + params['test_set'] + '/'
    if not os.path.exists(save_dir):
        os.makedirs(save_dir)
    fname = save_dir + params['subject'] + '_' + params['train_set'] + '_' + params['test_set'] \
            + '_results_' + type + '_' + scorer + '_' + gatordiag + '_' + params['baseline_correction']
    np.save(fname, results)
    print('saving done')
    print(fname)


def calcDecodingAlltimes(params):
    scores = list()
    for tmax in np.linspace(1.5, 2.4, 10):
        X_train = params['X_train']

        vec = X_train.Vectorizer()
        X_train_result = params['X_train'].copy().crop(tmin=tmin, tmax=tmax).get_data()
        X_test_result = params['X_test'].copy().crop(tmin=tmin, tmax=tmax).get_data()

        X_train_result = vec.fit_transform(X_train_result, params['y_train'])
        X_test_result = vec.fit_transform(X_test_result, params['y_test'])

        lda = LinearDiscriminantAnalysis()
        print('Fitting LDA')
        scores.append(cross_val_score(lda, X_train_result, y_train, scoring='confusion_matrix'))
        print('Done')

    return scores

