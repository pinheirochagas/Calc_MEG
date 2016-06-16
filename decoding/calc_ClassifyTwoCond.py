# This function runs a two-class or multiclass classification across conditions 
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
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline
from sklearn.cross_validation import StratifiedKFold

def calc_ClassifyTwoCond(X_train, y_train, X_test, y_test, params):
    "This function performs a simple two-class classification."
    
    #Initialize output variable
    score = []
    
    ###Learning machinery###
   
    #Scaler
    scaler = StandardScaler();
   
    #Model
    model = svm.SVC(C = 1, kernel = 'linear', class_weight = 'balanced')
   
    #Pipeline
    clf = make_pipeline(scaler, model)
   
    #Cross-validation
    cv = StratifiedKFold(y_train, 5)
   
    ###Learning process###
    #gat = GeneralizationAcrossTime(clf = clf, cv = cv, n_jobs = -1, train_times = params['trainingTime'], test_times = params['testingTime'], predict_mode = 'mean-prediction')
    gat = GeneralizationAcrossTime(clf = clf, cv = cv, n_jobs = -1, predict_mode = 'mean-prediction')
    #gat = GeneralizationAcrossTime(clf = clf, cv = cv, n_jobs = -1)
    gat.fit(X_train, y = y_train)
    score = gat.score(X_test, y = y_test)
    
    score = np.array(score)
    diagonal = np.diagonal(score)
   
    return gat, score, diagonal
