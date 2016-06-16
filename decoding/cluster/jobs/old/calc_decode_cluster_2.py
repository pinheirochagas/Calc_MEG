
# coding: utf-8

# In[ ]:

# Function to decode operation


# In[1]:

import mne
from mne.datasets import spm_face
from mne.decoding import GeneralizationAcrossTime
import sys
import os.path as op
import numpy as np
import matplotlib.pyplot as plt
import scipy.io as sio
import pandas as pd
from scipy import stats
#Add personal functions to python path
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding/')
#sys.path.append('/Volumes/NeuroSpin2T/Calculation_Pedro_2014/scripts/decoding/')
from fldtrp2mne_calc import fldtrp2mne_calc
from calc_ClassifyTwoCond import calc_ClassifyTwoCond
from sklearn import svm
from sklearn.cross_validation import cross_val_score, StratifiedShuffleSplit
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.feature_selection import SelectKBest, f_classif
from sklearn.pipeline import make_pipeline
from sklearn.cross_validation import StratifiedKFold


# In[2]:

#Directories
data_path = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/mat/'
result_path = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/data/decoding/'
#data_path = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/data/mat/'
#result_path = '/Volumes/NeuroSpin2T/Calculation_Pedro_2014/data/decoding/'

#Subjects
subjects = ['s01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 
            's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18','s19', 's21', 's22']

#General parameters
baseline = (-0.5, -0.05)

downsmpDec = 4

#Decoding
trainset = 'op1'
testset = 'presResCor'
decCond = ['op1_presResCor']

params = {'baseline': baseline, 'downsmpDec': downsmpDec, 'Classification': decCond, 
          'trainset': trainset, 'testset': testset}

#Results initialization
all_scores = []
all_diagonals = []


# In[ ]:




# In[7]:

for sub in subjects:
    #Load data
    fname= op.join(data_path, sub + '_calc.mat') 
    epoch,info = fldtrp2mne_calc(fname, 'data', 'calc')

    #Baseline-correct & filter data
    print('Baseline-correcting data for subject: ' + sub)
    epoch.apply_baseline(baseline)


    #Define sets index and trialinfo  
    idx_trainSet = info['operand1'] < 999 # just take all trials
    idx_testSet = (info['absdeviant'] != 0) & (info['preResult'] >= 3) & (info['preResult'] <= 6) & (info['preResult'] != info['operand1'])
    info_train = info[idx_trainSet]
    info_test = info[idx_testSet]

    # Correct the cue labels
    labels_train = 'operand1'
    labels_test = 'preResult'
    
    #idx_testSet = idx_trainSet
    #info_test = info_train
    #labels_test = labels_train

    # Decoding train
    X_train = epoch[idx_trainSet] #
    # Crop train epochs
    X_train = X_train.crop(tmin=X_train.times[75], tmax=X_train.times[325]) # crop from -200 to 800 ms
    y_train = np.array(info_train[labels_train]) #
    y_train = y_train.astype(np.float64)
    # Downsampling for decoding
    X_train.decimate(downsmpDec)
    #params.update({'testingTime':np.array(X_train.times)}) #Define test time
    # Correct the above line by something like this:
    # trainTime = {'start': 0, 'stop': 0.833, 'step': 0.833, 'length': 0.833}
    
    # Decoding test
    X_test = epoch[idx_testSet]#
    # Crop test epochs
    X_test = X_test.crop(tmin=X_test.times[325], tmax=X_test.times[-1]) # crop from -200 on
    y_test = np.array(info_test[labels_test]) #
    y_test = y_test.astype(np.float64)
    # Downsampling for decoding
    X_test.decimate(downsmpDec)
    #params.update({'testingTime':np.array(X_test.times)}) #Define test time

    print('Decoding subject: ' + sub)
    gat, score, diagonal = calc_ClassifyTwoCond(X_train, y_train, X_test, y_test, params)
    #gat.plot_diagonal()  # plot decoding across time (correspond to GAT diagonal)
    #Store scores of different subjects in the same list
    all_scores.append(score)
    all_diagonals.append(diagonal)
    
#Transform into a numpy array   
all_scores = np.array(all_scores)
all_diagonals = np.array(all_diagonals)

# Save individual results
fname = op.join(result_path, 'Classification_ ' + '_Trainset_' + trainset + '_Testset_2' + testset) 
np.save(fname, all_scores)
fname = op.join(result_path, 'Op1Res_train_times') 
np.save(fname, X_train.times)
fname = op.join(result_path, 'Op1Res_test_times') 
np.save(fname, X_test.times)

# Compute group averages
group_scores = np.mean(all_scores, 0)
sem_group_scores = stats.sem(all_scores, 0)

group_diagonal = np.mean(all_diagonals, 0)
sem_group_diagonal = stats.sem(all_diagonals, 0)