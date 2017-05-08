import numpy as np
from sklearn.base import BaseEstimator, TransformerMixin


class Averager(BaseEstimator, TransformerMixin):
    """Average data set into n samples"""
    def __init__(self, n, mean=None):
        if mean is None:
            mean = np.mean
        self.n = int(n)
        self.mean = mean

    def fit(self, X, y=None):
        return self

    def transform(self, X):
        if len(X) <= self.n:
            return X
        Xt = np.zeros((self.n, X.shape[1]))
        y = np.round(np.arange(len(X)) / float(len(X)) * self.n)
        self.y_ = y
        for ii in range(self.n):
            sel = np.where(y == ii)[0]
            Xt[ii, ...] = self.mean(X[sel, ...], axis=0)
        return Xt
