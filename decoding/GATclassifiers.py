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
from sklearn.cross_validation import StratifiedKFold
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import f_classif
from initDirs import dirs

def calcClassification(X_train, y_train, X_test, y_test, scorer, predict_mode, params):
    " Multiclass classification within or across conditions "

    # Initialize output variable
    score = []

    # Learning machinery

    # Scaler
    scaler = StandardScaler()

    # Model
    model = svm.SVC(C=1, kernel='linear', class_weight='balanced')
    # model = svm.SVC(C=1, kernel='linear', probability='True', class_weight='balanced', decision_function_shape='ovo')
    # probability='true' probably comes with pred label and probability

    # Feature selection
    fs = SelectKBest(f_classif, k=153)

    # Pipeline
    clf = make_pipeline(fs, scaler, model)

    # Cross-validation
    cv = StratifiedKFold(y_train, 5)


    # Define scorer
    if scorer is 'scorer_auc':
        from jr.gat.scorers import scorer_auc
        scorer = scorer_auc
    elif scorer is 'accuracy':
        scorer = None
    else:
        print('using accuracy as the scorer')

    # Learning process
    gat = GeneralizationAcrossTime(clf=clf, cv=cv, train_times=params['train_times'],
                                   test_times=params['test_times'], scorer=scorer, predict_mode=predict_mode, n_jobs=1)

    # CHECK THIS, gave error TypeError: an integer is required

    # Determine whether to generalize only across time or also across conditions
    if predict_mode == 'cross-validation':
        gat.fit(X_train, y=y_train)
        gat.score(X_train, y=y_train)
    elif predict_mode == 'mean-prediction':
        gat.fit(X_train, y=y_train)
        gat.score(X_test, y=y_test)

    # Organize and save
    score = np.array(gat.scores_)
    diagonal = np.diagonal(score)
    y_pred = np.array(gat.y_pred_)

    return y_pred, score, diagonal


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
    cv = StratifiedKFold(y_train, 5)

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
                                   test_times=params['test_times'], scorer=scorer, predict_mode=predict_mode, n_jobs=8)

    # Determine whether to generalize only across time or also across conditions
    if predict_mode == 'cross-validation':
        gat.fit(X_train, y=y_train)
        gat.score(X_train, y=y_train)
    elif predict_mode == 'mean-prediction':
        gat.fit(X_train, y=y_train)
        gat.score(X_test, y=y_test)

    # Organize and save
    score = np.array(gat.scores_)
    diagonal = np.diagonal(score)
    y_pred = np.array(gat.y_pred_)

    return y_pred, score, diagonal


    # print(gat)
    # results = ({'params': params, 'gat': gat})
    # fname = dirs['result'] + 'individual_results/GAT'
    # np.save(fname, results)
    # print('GAT saved!')
