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


def classifyGeneralCrossCond(X_train, X_test, y_train, y_test):

    #Define classifier
    # Classifiers
    clfs = OrderedDict()

    clfs['ERPCov'] = make_pipeline(
        UnsupervisedSpatialFilter(PCA(70), average=False),
        ERPCovariances(estimator='lwf'),
        TangentSpace('logeuclid'),
        LogisticRegression(class_weight='balanced'))

    columns = ['ERPCov_0-700']

    # Prelocate results
    results_train = pd.DataFrame(columns=columns)
    results_test = pd.DataFrame(columns=columns)

    #Prepare data
    X_train = 1e12 * np.array(X_train)
    X_test = 1e12 * np.array(X_test)

    # Prelocade predictions
    preds_train = np.zeros((X_train.shape[0], len(clfs)))

    # Cross validation
    cv = StratifiedKFold(y_train, 8)

    # Train model - LEARNING
    for jj, clf in enumerate(clfs):
        print('fitting and scoring ' + clf)
        count = 0
        for train, test in cv:
            print('cross-validation fold ' + str(count))
            clfs[clf].fit(X_train[train], y_train[train])
            # get the predictions
            pr = clfs[clf].predict(X_train[test])
            preds_train[test, jj] += pr
            count = count + 1

        results_train.loc[0, columns[0]] = accuracy_score(y_train, preds_train[:, jj])
        print('done!')

    # Test model
    print('scoring independent test set')
    preds_test = np.zeros((X_train.shape[0], len(clfs)))

    for jj, clf in enumerate(clfs):
        clfs[clf].fit(X_train, y_train)
        pr = clfs[clf].predict(X_test)
        preds_test[:, jj] += pr
        # Score
        results_test.loc[0, columns[0]] = accuracy_score(y_test, preds_test[:, jj])
    print('done!')

    return results_train, results_test, preds_train, preds_test, y_train, y_test