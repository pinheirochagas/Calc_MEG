# Author: Jean-Remi King <jeanremi.king@gmail.com>
#
# License: BSD (3-clause)

import numpy as np
import warnings
import scipy.sparse as sp
from sklearn.base import BaseEstimator
from sklearn.svm import SVC, LinearSVC, LinearSVR
from sklearn.linear_model import Ridge
from sklearn.calibration import CalibratedClassifierCV


class SSSLinearClassifier(object):

    def __init__(self, clf, cv=None, n_repeats=10, random_state=0,
                 mean_attributes=['intercept_', 'coef_'], train_size=None,
                 test_size=.2):
        self._clf = clf
        self._cv = cv
        self._n_repeats = n_repeats
        self._random_state = random_state
        self._train_size = train_size
        self._test_size = test_size
        self._mean_attributes = mean_attributes

    def fit(self, X, y):
        from copy import deepcopy
        from sklearn.cross_validation import StratifiedShuffleSplit
        cv = StratifiedShuffleSplit(y, self._n_repeats,
                                    train_size=self._train_size,
                                    test_size=self._test_size,
                                    random_state=self._random_state)
        attr = dict()
        for key in self._mean_attributes:
            attr[key] = list()
        # fit and collect classifiers attributes
        for train, test in cv:
            self._clf.fit(X[train], y[train])
            for key in self._mean_attributes:
                attr[key].append(deepcopy(self._clf.__getattribute__(key)))

        for key in self._mean_attributes:
            self._clf.__setattr__(key, np.mean(attr[key], axis=0))

    def predict(self, X):
        return self._clf.predict(X)

    def predict_proba(self, X):
        return self._clf.predict_proba(X)

    def get_params(self, deep=True):
        return dict(clf=self._clf, cv=self._cv,
                    n_repeats=self._n_repeats, random_state=self._random_state,
                    mean_attributes=self._mean_attributes,
                    train_size=self._train_size, test_size=self._test_size)


class force_predict(object):
    def __init__(self, clf, mode='predict_proba', axis=0):
        import warnings
        warnings.warn('Note that GeneralizationAcrossTime has now flexible' +
                      'predict functions')
        self._mode = mode
        self._axis = axis
        self._clf = clf

    def fit(self, X, y, **kwargs):
        self._clf.fit(X, y, **kwargs)
        self._copyattr()

    def predict(self, X):
        if self._mode == 'predict_proba':
            proba = self._clf.predict_proba(X)
            if self._axis == 'all':
                pass
            elif type(self._axis) in [int, list]:
                proba = proba[:, self._axis]
            return proba
        elif self._mode == 'decision_function':
            distances = self._clf.decision_function(X)
            if (len(distances.shape) == 1) or (self._axis == 'all'):
                pass
            elif type(self._axis) in [int, list]:
                distances = distances[:, self._axis]
            return distances
        else:
            return self._clf.predict(X)

    def get_params(self, deep=True):
        return dict(clf=self._clf, mode=self._mode, axis=self._axis)

    def _copyattr(self):
        for key, value in self._clf.__dict__.iteritems():
            self.__setattr__(key, value)


class force_weight(object):
    def __init__(self, clf, weights=None):
        self._clf = clf

    def fit(self, X, y):
        return self._clf.fit(X, y[:, 0], sample_weight=y[:, 1])

    def predict(self, X):
        return self._clf.predict(X)

    def get_params(self, deep=True):
        return dict(clf=self._clf)


def LinearSVC_Proba(probability=False, method='sigmoid', cv=5, **kwargs):
    if probability is True:
        base_estimator = LinearSVC(**kwargs)
        return CalibratedClassifierCV(base_estimator=base_estimator,
                                      method=method, cv=cv)
    else:
        return LinearSVC(**kwargs)


def SVC_Light(probability=False, method='sigmoid', cv=5, **kwargs):
    """
    Similar to SVC(kernel='linear') without having to store 'support_vectors_'
     and '_dual_coef_'.
    Uses CalibrationClassifierCV if probability=True.
    """
    if probability is True:
        base_estimator = _SVC_Light(probability=True, **kwargs)
        return _SVC_Light_Proba(base_estimator=base_estimator, method=method,
                                cv=cv)
    else:
        return _SVC_Light(**kwargs)


class _SVC_Light_Proba(CalibratedClassifierCV):

    def decision_function(self, X):
        warnings.warn(
            "With 'probability=True' decision_function=predict_proba")
        return self.predict_proba(X)

    def fit(self, X, y):
        if len(np.unique(y)) > 2:
            # XXX
            raise ValueError('_SVC_Light currently does not support '
                             'probability=True for more than 2 classes.')
        super(_SVC_Light_Proba, self).fit(X, y)


class _SVC_Light(SVC):
    """
    Similar to SVC(kernel='linear') without having to store 'support_vectors_'
     and '_dual_coef_'
    """

    def __init__(self, kernel='linear', probability=False, **kwargs):
        if 'kernel' in kwargs.keys():
            raise ValueError('SVC_Light is only available when using a '
                             'linear kernel.')
        if 'probability' in kwargs.keys():
            raise RuntimeError('Currently, SVC_Light does not support '
                               'probability=True')
        super(_SVC_Light, self).__init__(kernel=kernel,
                                         probability=probability, **kwargs)

    def fit(self, X, y, scaling=None):
        super(_SVC_Light, self).fit(X, y)
        # compute coef from support vectors once only
        self._coef_ = self._compute_coef_()
        self.__delattr__('support_vectors_')
        self.__delattr__('_dual_coef_')

    def _compute_coef_(self):
        # Originally coef_(self) from SVC
        coef = self._get_coef()
        if sp.issparse(coef):
            coef.data.flags.writeable = False
        else:
            coef.flags.writeable = False
        return coef

    def predict(self, X):
        from gat.predicters import predict_OneVsOne
        distances = self.decision_function(X)
        y_pred = predict_OneVsOne(distances, self.classes_)
        return y_pred

    def decision_function(self, X):
        X = self._validate_for_predict(X)
        n_sample = X.shape[0]
        intercept = np.tile(self.intercept_, (n_sample, 1))
        distances = np.dot(self.coef_, X.T).T + intercept
        if len(self.classes_) == 2:
            distances *= -1
        return distances

    @property
    def coef_(self):
        return self._coef_


class PolarRegression(BaseEstimator):

    def __init__(self, clf=None, independent=True):
        import copy
        if clf is None:
            clf = LinearSVR()
        self.clf = clf
        if independent:
            self.clf_cos = copy.deepcopy(clf)
            self.clf_sin = copy.deepcopy(clf)
        self.independent = independent

    def fit(self, X, y):
        """
        Fit 2 regressors cos and sin of angles y
        Parameters
        ----------
        X : np.array, shape(n_trials, n_chans, n_time)
            MEG data
        y : list | np.array (n_trials, 2)
            angle in radians and radius. If no radius is provided, takes r=1.
        """
        if y.ndim == 1:
            y = np.vstack((y, np.ones_like(y))).T
        cos = np.cos(y[:, 0]) * y[:, 1]
        sin = np.sin(y[:, 0]) * y[:, 1]
        if self.independent:
            self.clf_cos.fit(X, cos)
            self.clf_sin.fit(X, sin)
        else:
            self.clf.fit(X, np.vstack((cos, sin)).T)

    def predict(self, X):
        """
        Predict orientation from MEG data in radians
        Parameters
        ----------
        X : np.array, shape(n_trials, n_chans, n_time)
            MEG data
        Returns
        -------
        predict_angle : list | np.array, shape(n_trials)
            angle predictions in radian
        """
        if self.independent:
            predict_cos = self.clf_cos.predict(X)
            predict_sin = self.clf_sin.predict(X)
        else:
            predict_cossin = self.clf.predict(X)
            predict_cos = predict_cossin[:, 0]
            predict_sin = predict_cossin[:, 1]
        predict_angle = np.arctan2(predict_sin, predict_cos)
        predict_radius = np.sqrt(predict_sin ** 2 + predict_cos ** 2)
        y_pred = np.concatenate((predict_angle.reshape([-1, 1]),
                                 predict_radius.reshape([-1, 1])), axis=1)
        return y_pred


class AngularRegression(PolarRegression):
    def predict(self, X):
        return super(AngularRegression, self).predict(X)[:, 0]


class SVR_polar(PolarRegression):  # FIXME deprecate

    def __init__(self, clf=None, C=1, **kwargs):
        from sklearn.preprocessing import StandardScaler
        from sklearn.pipeline import make_pipeline
        import warnings
        warnings.warn('Prefer using PolarRegression(). Will be deprecated')
        if clf is None:
            clf = LinearSVR(C=C, **kwargs)
        self.clf = make_pipeline(StandardScaler(), clf)
        self.C = C
        self.kwargs = kwargs
        super(SVR_polar, self).__init__(clf=clf, independent=True)


class SVR_angle(SVR_polar):  # FIXME deprecate
    def predict(self, X):
        return super(SVR_angle, self).predict(X)[:, 0]
