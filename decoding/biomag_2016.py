import numpy as np
import pandas as pd
from collections import OrderedDict

from scipy.io import loadmat

from mne.decoding import UnsupervisedSpatialFilter
from sklearn.decomposition import PCA
from sklearn.cross_validation import KFold
from sklearn.pipeline import make_pipeline
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import roc_auc_score

from pyriemann.spatialfilters import CSP
from pyriemann.tangentspace import TangentSpace
from pyriemann.estimation import (ERPCovariances, XdawnCovariances,
                                  HankelCovariances)


def epoch_data(data, window=125, offset=0):
    """Epoch data"""
    MEG, trigger = data['planardat'], data['triggers']

    X, y = list(), list()

    trials = np.r_[trigger.t1, trigger.t2, trigger.t3,
                   trigger.t4, trigger.t5, trigger.t6]

    values = np.array([0]*len(trigger.t1) + [1]*len(trigger.t2) +
                      [2]*len(trigger.t3) + [3]*len(trigger.t4) +
                      [4]*len(trigger.t5) + [5]*len(trigger.t6))

    # Epoch training set
    ix = np.argsort(trials)
    trials, values = trials[ix], values[ix]
    for ii, start in enumerate(trials):
        X.append(MEG[:, slice(start + offset, start + window + offset)])
        y.append(values[ii])

    # Epoch testing set
    X_test = list()
    for t in trigger.test:
        sl = slice(t + offset, t + window + offset)
        # Stack zeros on last trials in case window is too long
        epoch = np.zeros((len(MEG), window))
        epoch[:, :len(MEG[0, sl])] = MEG[:, sl]
        X_test.append(epoch)

    # Format
    X = 1e12 * np.array(X)
    X_test = 1e12 * np.array(X_test)
    y = np.array(y) == 3

    return X, y, X_test


def local_debias(y_preds):
    """The sum of each group of 12 trials must be 1."""
    y_preds = np.array(y_preds)
    y_preds = np.reshape(y_preds, (-1, 12))
    y_preds /= np.sum(y_preds, 1)[:, np.newaxis]
    return y_preds.ravel()


# CLassifiers
clfs = OrderedDict()
clfs['ERPCov'] = make_pipeline(
    UnsupervisedSpatialFilter(PCA(70), average=False),
    ERPCovariances(estimator='lwf'),
    CSP(30, log=False),
    TangentSpace('logeuclid'),
    LogisticRegression('l2'))

clfs['XdawnCov'] = make_pipeline(
    UnsupervisedSpatialFilter(PCA(50), average=False),
    XdawnCovariances(12, estimator='lwf', xdawn_estimator='lwf'),
    TangentSpace('logeuclid'),
    LogisticRegression('l2'))

clfs['HankelCov'] = make_pipeline(
    UnsupervisedSpatialFilter(PCA(70), average=False),
    HankelCovariances(delays=[1, 8, 12, 64], estimator='oas'),
    CSP(15, log=False),
    TangentSpace('logeuclid'),
    LogisticRegression('l2'))

offsets = [10, 20, 30, 40, 50]
results = pd.DataFrame(index=range(1, 5), columns=clfs.keys() + ['Ensemble'])
for subject in range(1, 5):
    # Load the data
    data = loadmat('./data/meg_data_%da.mat' % subject,
                   squeeze_me=True, struct_as_record=False)

    preds = np.zeros((240, len(clfs)))

    for offset in offsets:
        # Epoching
        X, y, _ = epoch_data(data, window=150, offset=offset)

        # define CV and prediction
        cv = KFold(len(y), n_folds=10, shuffle=False, random_state=4343)

        # iterate over models and train/test partitions
        for jj, clf in enumerate(clfs):
            for train, test in cv:
                clfs[clf].fit(X[train], y[train])

                # get the predictions
                pr = clfs[clf].predict_proba(X[test])[:, -1]
                preds[test, jj] += local_debias(pr)

            results.loc[subject, clf] = roc_auc_score(y, preds[:, jj])
    auc = roc_auc_score(y, local_debias(preds.mean(1)))
    results.loc[subject, 'Ensemble'] = auc

results.loc['Mean', :] = results.mean()
results