import sys 
sys.path.append('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calc_MEG/scripts_git/Calc_MEG/decoding')
from calc_decoding_cfg import (data_path, baseline, downsampling, trainTimes, testTimes)
from fldtrp2mne_calc import fldtrp2mne_calc
import numpy as np

import mne
import pandas as pd



subjects = ['s03', 's04', 's05', 's06', 's07', 's08', 's09', 's10','s11', 's13', 's14', 's15', 's16', 's17', 's18','s19', 's22']

scores = list()
for Subject in subjects:
    print('Subject %s' % Subject)
    Condition = ['corrResult', 'corrResult']
    Type = 'class'
    #Decoding
    trainset = Condition[0] # and then this will be already known when calling the function
    testset = Condition[1]

    params = {'baseline': baseline, 'downsampling': downsampling,
    'classification': Condition, 'trainset': trainset,
    'testset': testset, 'trainTimes': trainTimes, 'testTimes': testTimes}

    fname_calc = data_path + '/' + Subject + '_calc.mat'
    print('Loading data from FT')
    epoch_calc,info_calc = fldtrp2mne_calc(fname_calc, 'data', 'calc')
    epoch_calc.pick_types(meg='grad')
    print('Done')

    # Select trials
    train_index = (info_calc['corrResult'] > 2) & (info_calc['corrResult'] < 7)
    test_index = (info_calc['corrResult'] > 2) & (info_calc['corrResult'] < 7)
    X_train = epoch_calc[train_index]
    y_train = np.array(info_calc[train_index]['corrResult'])
    y_train = y_train.astype(np.float64)
    X_test = epoch_calc[test_index]
    y_test = np.array(info_calc[test_index]['corrResult'])
    y_test = y_test.astype(np.float64)
    tmin, tmax = 1.5, 2.4




    for tmax in np.linspace(1.5, 2.4, 10):

        from mne.decoding import EpochsVectorizer
        vec = EpochsVectorizer(epoch_calc.info)
        X_train_result = X_train.copy().crop(tmin=tmin, tmax=tmax).get_data()
        X_test_result = X_test.copy().crop(tmin=tmin, tmax=tmax).get_data()

        X_train_result = vec.fit_transform(X_train_result, y_train)
        X_test_result = vec.fit_transform(X_test_result, y_test)

        from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
        from sklearn.cross_validation import cross_val_score

        lda = LinearDiscriminantAnalysis()
        print('Fitting LDA')
        scores.append(cross_val_score(lda, X_train_result, y_train,
                      scoring='confusion_matrix'))
        print('Done')
sdfdf


gat, score, diagonal = calc_classification(X_train, y_train, X_test, y_test, params)






