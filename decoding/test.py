import numpy as np
from mne.decoding import GeneralizationAcrossTime
from sklearn import svm
from sklearn import linear_model
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline
from sklearn.cross_validation import StratifiedKFold
from initDirs import dirs


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
cv = StratifiedKFold(np.arange(1, 10, 1), 5)

gat = GeneralizationAcrossTime(clf=clf, cv=cv,  train_times={'start': -0.2, 'stop': 3.2},
                               test_times='diagonal', scorer='accuracy', predict_mode='cross-validation', n_jobs=8)