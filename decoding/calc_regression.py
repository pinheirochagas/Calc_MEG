# This function runs a linear regression. 
# It takes as input a data matrix(X) and a label vector(y). 
# Calc_MEG
# Pinheiro-Chagas - 2016

###Load libraries###

#Basics
import numpy as np
import scipy.io as sio
import pandas as pd
#MNE
from mne.decoding import GeneralizationAcrossTime
#Sklearn
from sklearn import svm
from sklearn import linear_model
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline
from sklearn.cross_validation import StratifiedKFold
# Other tools
from jr.gat.scorers import kendall_score

def calc_regression(X_train, y_train, X_test, y_test, params):
    "This function performs a regression."
    
    #Initialize output variable
    score = []
    
    ###Learning machinery###
   
    #Scaler
    scaler = StandardScaler();
   
    #Model
    #model = svm.SVC(C = 1, kernel = 'linear', class_weight = 'balanced')
    model = linear_model.RidgeCV()
    #model =  linear_model.LinearRegression()
   
    #Pipeline
    clf = make_pipeline(scaler, model)
   
    #Cross-validation
    cv = StratifiedKFold(y_train, 5)

    #Define prediction mode
    predict_mode = params['mode']

    # Define scorer
    scorer = 'r2'
    #Define scorer
#    if params['scorer'] is 'scorer_auc':
#        scorer = scorer_auc
#    elif params['scorer'] is 'prob_accuracy':
#        scorer = prob_accuracy
#    elif params['scorer'] is 'scorer_angle':
#       scorer = prob_accuracy
    ###Learning process###

    #gat = GeneralizationAcrossTime(clf = clf, cv = cv, train_times = params['trainTimes'], 
        #test_times = params['testTimes'], scorer = scorer, predict_mode = predict_mode, n_jobs = 6)
        
    gat = GeneralizationAcrossTime(clf = clf, cv = cv, train_times = params['trainTimes'], 
        test_times = params['testTimes'], scorer = scorer, predict_mode = predict_mode, n_jobs = 6)
    # gat.fit(X_train, y = y_train)
    # score = gat.score(X_train, y = y_train)

    #Determine whether to generalize only across time or also across conditions
    if predict_mode == 'cross-validation':
        gat.fit(X_train, y = y_train)
        score = gat.score(X_train, y = y_train)
    elif predict_mode == 'mean-prediction':
        gat.fit(X_train, y = y_train)        
        score = gat.score(X_test, y = y_test)
    
    score = np.array(score)
    diagonal = np.diagonal(score)
   
    return gat, score, diagonal
