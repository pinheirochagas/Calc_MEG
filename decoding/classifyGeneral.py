# Libraries
import os
import numpy as np
import pandas as pd
from collections import OrderedDict
from scipy.io import loadmat
from mne.decoding import UnsupervisedSpatialFilter
from mne.decoding import Vectorizer

from sklearn.decomposition import PCA
from sklearn.cross_validation import KFold
from sklearn.pipeline import make_pipeline
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import roc_auc_score
from sklearn.metrics import accuracy_score
from pyriemann.spatialfilters import CSP
from pyriemann.tangentspace import TangentSpace
from pyriemann.estimation import (ERPCovariances, XdawnCovariances,
                                  HankelCovariances)
from sklearn.cross_validation import StratifiedKFold
from sklearn import svm
from initDirs import dirs
from prepDataDecoding import prepDataDecoding


def classifyGeneral(X, y):

    #Define classifier
    # Classifiers
    clfs = OrderedDict()

    clfs['ERPCov'] = make_pipeline(
        UnsupervisedSpatialFilter(PCA(70), average=False),
        ERPCovariances(estimator='lwf'),
        TangentSpace('logeuclid'),
        svm.SVC(C=1, kernel='linear', class_weight='balanced'))

    # Define sliding window,
    # offsets = np.arange(0,400, 100)  # if epoch size is 3,200 ms and sampling rate 125Hz
    # window = 100

    # offsets = np.arange(0,100, 50)  # if epoch size is 1.6 ms and sampling rate 125Hz
    # window = 50

    # offsets = np.arange(0,100, 100)
    # window = 10

    # offsets = np.arange(0,50, 12)
    # window = 12

    #columns = ['ERPCov_0-800', 'ERPCov_800-1600', 'ERPCov_1600-2400', 'ERPCov_2400-3200']
    columns = ['ERPCov_0-400', 'ERPCov_400-800']  # these columns should be = len(offsets)

    # Prelocate results
    results = pd.DataFrame(columns=columns)
    # results = pd.DataFrame(index=offsets, columns=clfs.keys())

    #Prepare data
    X_tmp = 1e12 * np.array(X)

    # Prelocade predictions
    preds = np.zeros((X.shape[0], len(clfs), len(offsets)))

    count_offset = 0
    for offset in offsets:
        X = X_tmp[:,:,offset:offset+window]

        cv = StratifiedKFold(y, 8)

        # iterate over models and train/test partitions
        for jj, clf in enumerate(clfs):
            print('fitting and scoring ' + clf)
            count = 0
            for train, test in cv:
                print('cross-validation fold ' + str(count))
                clfs[clf].fit(X[train], y[train])
                # get the predictions
                pr = clfs[clf].predict(X[test])
                preds[test, jj, count_offset] += pr
                count = count + 1

            results.loc[0,columns[count_offset]] = accuracy_score(y, preds[:, jj, count_offset])
            count_offset = count_offset + 1

    return results, preds, y

    # define CV and prediction
    # cv = KFold(len(y), n_folds=10, shuffle=False, random_state=4343)
    # cv = StratifiedKFold(y, 8)

# Other classifiers

    # clfs['XdawnCov'] = make_pipeline(
    #    UnsupervisedSpatialFilter(PCA(50), average=False),
    #    XdawnCovariances(12, estimator='lwf', xdawn_estimator='lwf'),
    #    TangentSpace('logeuclid'),
    #    svm.SVC(C=1, kernel='linear', class_weight='balanced'))
    #
    # clfs['HankelCov'] = make_pipeline(
    #     UnsupervisedSpatialFilter(PCA(70), average=False),
    #     HankelCovariances(delays=[1, 8, 12, 64], estimator='oas'),
    #     TangentSpace('logeuclid'),
    #     LogisticRegression('l2'))
    #
    # clfs['SimpleSVM'] = make_pipeline(Vectorizer(), svm.SVC(C=1, kernel='linear', class_weight='balanced'))