# This function runs a simple two-class or multiclass classification. 
# It takes as input a data matrix(X) and a label vector(y). 
# Calc_MEG
# Pinheiro-Chagas - 2016

###Load libraries###

# Basics
import numpy as np
import scipy.io as sio
import pandas as pd
# MNE
from mne.decoding import GeneralizationAcrossTime
# Sklearn
from sklearn import svm
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline
from sklearn.cross_validation import StratifiedKFold

from jr.gat.scorers import scorer_auc


def calc_classification(X_train, y_train, X_test, y_test, params):
    "This function performs a multiclass classification within or across conditions."

    # Initialize output variable
    score = []

    ### Learning machinery###

    # Scaler
    scaler = StandardScaler();

    # Model
    model = svm.SVC(C=1, kernel='linear', class_weight='balanced')

    # Pipeline
    clf = make_pipeline(scaler, model)

    # Cross-validation
    cv = StratifiedKFold(y_train, 5)

    # Define prediction mode
    predict_mode = params['mode']

    # Define score
    scorer = scorer_auc
    #    if params['scorer'] is 'scorer_auc':
    #        scorer = scorer_auc
    #    elif params['scorer'] is 'prob_accuracy':
    #        scorer = prob_accuracy
    #    elif params['scorer'] is 'scorer_angle':
    #       scorer = prob_accuracy

    ###Learning process###
    # gat = GeneralizationAcrossTime(clf = clf, cv = cv, predict_mode = predict_mode, 
    #     scorer = scorer, n_jobs = -1)

    gat = GeneralizationAcrossTime(clf=clf, cv=cv,  train_times=params['trainTimes'],
                                   test_times=params['testTimes'], scorer=scorer, predict_mode=predict_mode, n_jobs=8)

    # gat = GeneralizationAcrossTime(clf=clf, cv=cv, train_times=params['trainTimes'],
                                   # test_times=params['testTimes'], predict_mode=predict_mode, n_jobs=32)
    # Determine whether to generalize only across time or also across conditions
    if predict_mode == 'cross-validation':
        gat.fit(X_train, y=y_train)
        score = gat.score(X_train, y=y_train)
    elif predict_mode == 'mean-prediction':
        gat.fit(X_train, y=y_train)
        score = gat.score(X_test, y=y_test)

    score = np.array(score)
    diagonal = np.diagonal(score)

    return gat, score, diagonal
