# GAT functions
# Calc MEG
# Pinheiro-Chagas 2017

# Packages
import numpy as np
from mne.decoding import GeneralizationAcrossTime
from sklearn import svm
from sklearn import linear_model
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline
#from sklearn.model_selection import StratifiedKFold
from sklearn.cross_validation import StratifiedKFold

from sklearn.metrics import roc_auc_score
from jr.gat.scorers import scorer_auc
from jr.gat.scorers import _parallel_scorer
#from sklearn.feature_selection import SelectKBest
#from sklearn.feature_selection import f_classif
#from initDirs import dirs


import numpy as np

from mne.decoding import UnsupervisedSpatialFilter
from sklearn.decomposition import PCA
from pyriemann.tangentspace import TangentSpace
from pyriemann.estimation import (ERPCovariances, XdawnCovariances,
                                  HankelCovariances)

def calcClassification(X_train, y_train, X_test, y_test, scorer, predict_mode, params):
    " Multiclass classification within or across conditions "

    # Learning machinery

    # Initialize output variable
    score = []

    # Cross-validation
    # cv = StratifiedKFold(y_train, 5)
    cv = StratifiedKFold(y_train, 8)
    #cv = StratifiedKFold(n_splits=8, random_state=0, shuffle=True)

    # Scaler
    scaler = StandardScaler()

    # Model
    # Define scorer
    if scorer is 'scorer_auc':
        scorer = 'roc_auc'
        predict_method = 'predict_proba'
        model = svm.SVC(C=1, kernel='linear', class_weight='balanced', probability='True')
    elif scorer is 'accuracy':
        scorer = None
        predict_method = 'predict'
        model = svm.SVC(C=1, kernel='linear', class_weight='balanced')
    else:
        print('using accuracy as the scorer')

    # model = svm.SVC(C=1, kernel='linear', probability='True', class_weight='balanced', decision_function_shape='ovo')
    # probability='true' probably comes with pred label and probability

    # Feature selection - HAVE TO DECIDE ON THAT!
    # fs = SelectKBest(f_classif, k=153)


    # Pipeline
    #clf = make_pipeline(scaler, model)
    clf = make_pipeline(
        UnsupervisedSpatialFilter(PCA(50), average=False),
        XdawnCovariances(12, estimator='lwf', xdawn_estimator='lwf'),
        TangentSpace('logeuclid'),
        svm.SVC(C=1, kernel='linear', class_weight='balanced'))

    # clf = make_pipeline(fs, scaler, model)

    # Learning process
    gat = GeneralizationAcrossTime(clf=clf, cv=cv, train_times=params['train_times'], test_times=params['test_times'],
                                   scorer=scorer, predict_mode=predict_mode, predict_method=predict_method, n_jobs=1)

    # CHECK THIS, gave error TypeError: an integer is required

    # Determine whether to generalize only across time or also across conditions
    if predict_mode == 'cross-validation':
        print('fitting')
        gat.fit(X_train, y=y_train)
        print('done fitting')
        print('scoring')
        gat.score(X_train, y=y_train)
        print('done scoring')
    elif predict_mode == 'mean-prediction':
        print('fitting')
        gat.fit(X_train, y=y_train)
        print('done fitting')
        print('scoring')
        gat.score(X_test, y=y_test)
        print('done scoring')

    # Organize and save
    score = np.array(gat.scores_)
    diagonal = np.diagonal(score)
    y_pred = np.array(gat.y_pred_)
    y_true = np.array(gat.y_true_)

    return y_true, y_pred, score, diagonal


def calcRegression(X_train, y_train, X_test, y_test, scorer, predict_mode, params):
    " Regression within or across conditions "

    # Initialize output variable
    score = []

    # Learning machinery

    # Scaler
    scaler = StandardScaler()

    # Model
    model = linear_model.RidgeCV()

    # Pipeline
    clf = make_pipeline(scaler, model)

    # Cross-validation
    cv = StratifiedKFold(y_train, 8)

    # Define scorer
    if scorer is 'scorer_auc':
        from jr.gat.scorers import scorer_auc
        scorer = scorer_auc
    elif scorer is 'kendall_score':
        from jr.gat.scorers import kendall_score
        scorer = kendall_score
    elif scorer is 'accuracy':
        scorer = None
    else:
        print('using accuracy as the scorer')

    ###Learning process###
    gat = GeneralizationAcrossTime(clf=clf, cv=cv, train_times=params['train_times'],
                                   test_times=params['test_times'], scorer=scorer, predict_mode=predict_mode, n_jobs=1)

    # Determine whether to generalize only across time or also across conditions
    if predict_mode == 'cross-validation':
        print('fitting')
        gat.fit(X_train, y=y_train)
        print('done fitting')
        print('scoring')
        gat.score(X_train, y=y_train)
        print('done scoring')
    elif predict_mode == 'mean-prediction':
        print('fitting')
        gat.fit(X_train, y=y_train)
        print('done fitting')
        print('scoring')
        gat.score(X_test, y=y_test)
        print('done scoring')

    # Organize and save
    score = np.array(gat.scores_)
    diagonal = np.diagonal(score)
    y_pred = np.array(gat.y_pred_)
    y_true = np.array(gat.y_true_)

    return y_true, y_pred, score, diagonal



    # print(gat)
    # results = ({'params': params, 'gat': gat})
    # fname = dirs['result'] + 'individual_results/GAT'
    # np.save(fname, results)
    # print('GAT saved!')
