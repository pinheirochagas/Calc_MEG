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


def classifyGeneral(X, y, params):

    #Define classifier
    # Classifiers
    clfs = OrderedDict()

    clfs['XdawnCov'] = make_pipeline(
       UnsupervisedSpatialFilter(PCA(50), average=False),
       XdawnCovariances(12, estimator='lwf', xdawn_estimator='lwf'),
       TangentSpace('logeuclid'),
       svm.SVC(C=1, kernel='linear', class_weight='balanced'))

    clfs['ERPCov'] = make_pipeline(
        UnsupervisedSpatialFilter(PCA(70), average=False),
        ERPCovariances(estimator='lwf'),
        TangentSpace('logeuclid'),
        LogisticRegression('l2'))

    clfs['HankelCov'] = make_pipeline(
        UnsupervisedSpatialFilter(PCA(70), average=False),
        HankelCovariances(delays=[1, 8, 12, 64], estimator='oas'),
        TangentSpace('logeuclid'),
        LogisticRegression('l2'))

    clfs['SimpleSVM'] = make_pipeline(Vectorizer(), svm.SVC(C=1, kernel='linear', class_weight='balanced'))

    # Define sliding window
    offsets = np.arange(0,140,20)
    window = 60

    # Prelocate results
    results = pd.DataFrame(index=range(1,len(offsets)), columns=clfs.keys())

    #Prepare data
    X_tmp = 1e12 * np.array(X)

    # Prelocade predictions
    preds = np.zeros((X.shape[0], len(clfs)))
    for offset in offsets:
        X = X_tmp[:,:,offset:offset+window]

        # define CV and prediction
        # cv = KFold(len(y), n_folds=10, shuffle=False, random_state=4343)
        cv = StratifiedKFold(y, 8)

        # iterate over models and train/test partitions
        for jj, clf in enumerate(clfs):
            for train, test in cv:
                clfs[clf].fit(X[train], y[train])

                # get the predictions
                pr = clfs[clf].predict(X[test])
                preds[test, jj] += pr

            results.loc[offset,clf] = accuracy_score(y, preds[:, jj])

    # save_dir = dirs['result'] + 'individual_results/' + params['train_set'] + '_' + params['test_set'] + '/'
    # if not os.path.exists(save_dir):
    #     os.makedirs(save_dir)
    #
    # fname = save_dir + params['subject'] + '_' + params['train_set'] + '_' + params['test_set'] + '_results_general.csv'
    # results.to_csv(fname)
    # print(results)

    return results