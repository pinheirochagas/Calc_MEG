import sys 
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding/')


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
from sklearn.metrics import accuracy_score

from pyriemann.spatialfilters import CSP
from pyriemann.tangentspace import TangentSpace
from pyriemann.estimation import (ERPCovariances, XdawnCovariances,
                                  HankelCovariances)

from sklearn.cross_validation import StratifiedKFold
from sklearn import svm

from initDirs import dirs
from prepDataDecoding import prepDataDecoding

clfs = OrderedDict()
clfs['XdawnCov'] = make_pipeline(
    UnsupervisedSpatialFilter(PCA(50), average=False),
    XdawnCovariances(12, estimator='lwf', xdawn_estimator='lwf'),
    TangentSpace('logeuclid'),
    svm.SVC(C=1, kernel='linear', class_weight='balanced'))

### Train
subjects = ['s02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']
subjects = ['s17']

##
conditions = [['cres_riemann', 'cres_riemann']]
#conditions = [['addsub_riemann', 'addsub_riemann']]
baselinecorr = 'nobaseline'
dec_method = 'class'
dec_scorer = 'accuracy'
gatordiag = 'gat'
decimate = 2


results = pd.DataFrame(index=range(1, 1), columns=clfs.keys())

for s, subject in enumerate(subjects):
    # Load the data
    params = prepDataDecoding(dirs, conditions[0][0], conditions[0][1], subject, baselinecorr, decimate)
    epochs =  params['X_train']
    epochs.pick_types(meg='grad')
    X = epochs._data
    X = 1e12 * np.array(X)

    y = params['y_train']

    preds = np.zeros((X.shape[0], len(clfs)))

    # define CV and prediction
    #cv = KFold(len(y), n_folds=10, shuffle=False, random_state=4343)
    cv = StratifiedKFold(y, 8)

    # iterate over models and train/test partitions
    for jj, clf in enumerate(clfs):
        for train, test in cv:
            clfs[clf].fit(X[train], y[train])

            # get the predictions
            pr = clfs[clf].predict(X[test])
            preds[test, jj] += pr

        results.loc[subject, clf] = accuracy_score(y, preds[:, jj])

results.loc['Mean', :] = results[1:20].mean()

results.to_csv(dirs['gp_result'] + 'cres_riemann3.csv' )