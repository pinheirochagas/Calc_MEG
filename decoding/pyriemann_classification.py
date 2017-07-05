# Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
from calcDecoding import calcDecodingAlltimes
import numpy as np

# Subjects
#subjects = ['s01', 's02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
  #          's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']

subjects = ['s03', 's04', 's05', 's06', 's07', 's08', 's09', 's10',
            's11', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's22']

subject = 's03'

##
conditions = [['cres', 'cres']]
baselinecorr = 'nobaseline'
dec_method = 'class'
dec_scorer = 'accuracy'
gatordiag = 'gat'
decimate = 2

params = prepDataDecoding(dirs, conditions[0][0], conditions[0][1], subject, baselinecorr, decimate)




"""
====================================================================
Multiclass MEG ERP Decoding
====================================================================
Decoding applied to MEG data in sensor space decomposed using Xdawn.
After spatial filtering, covariances matrices are estimated and
classified by the MDM algorithm (Nearest centroid).
4 Xdawn spatial patterns (1 for each class) are displayed, as per the
for mean-covariance matrices used by the classification algorithm.
"""
# Authors: Alexandre Barachant <alexandre.barachant@gmail.com>
#
# License: BSD (3-clause)

import numpy as np
from matplotlib import pyplot as plt
from pyriemann.estimation import XdawnCovariances
from pyriemann.classification import MDM
from pyriemann.utils.viz import plot_confusion_matrix

import mne
from mne import io
from mne.datasets import sample

from sklearn.pipeline import make_pipeline
from sklearn.cross_validation import KFold
from sklearn.metrics import classification_report

print(__doc__)

data_path = sample.data_path()

###############################################################################
# Set parameters and read data
raw_fname = data_path + '/MEG/sample/sample_audvis_filt-0-40_raw.fif'
event_fname = data_path + '/MEG/sample/sample_audvis_filt-0-40_raw-eve.fif'
tmin, tmax = -0., 1
event_id = dict(aud_l=1, aud_r=2, vis_l=3, vis_r=4)

# Setup for reading the raw data
raw = io.Raw(raw_fname, preload=True)
raw.filter(2, None, method='iir')  # replace baselining with high-pass
events = mne.read_events(event_fname)

raw.info['bads'] = ['MEG 2443']  # set bad channels
picks = mne.pick_types(raw.info, meg='grad', eeg=False, stim=False, eog=False,
                       exclude='bads')

# Read epochs
epochs = mne.Epochs(raw, events, event_id, tmin, tmax, proj=False,
                    picks=picks, baseline=None, preload=True, verbose=False)

labels = epochs.events[:, -1]
evoked = epochs.average()

##


epochs = params['X_train']
epochs.pick_types(meg='grad')
labels = params['y_train']
epochs.events[:,-1] = labels
evoked = epochs.average()




###############################################################################
# Decoding with Xdawn + MDM

n_components = 3  # pick some components

# Define a monte-carlo cross-validation generator (reduce variance):
cv = KFold(len(labels), 10, shuffle=True, random_state=42)
pr = np.zeros(len(labels))
epochs_data = epochs.get_data()

print('Multiclass classification with XDAWN + MDM')

clf = make_pipeline(XdawnCovariances(n_components), MDM())

for train_idx, test_idx in cv:
    y_train, y_test = labels[train_idx], labels[test_idx]

    clf.fit(epochs_data[train_idx], y_train)
    pr[test_idx] = clf.predict(epochs_data[test_idx])

print(classification_report(labels, pr))

###############################################################################
# plot the spatial patterns
xd = XdawnCovariances(n_components)
xd.fit(epochs_data, labels)

evoked.data = xd.Xd_.patterns_.T
evoked.times = np.arange(evoked.data.shape[0])
evoked.plot_topomap(times=[0, n_components, 2 * n_components,
                    3 * n_components], ch_type='grad', colorbar=False,
                    size=1.5)

###############################################################################
# plot the confusion matrix
names = ['audio left', 'audio right', 'vis left', 'vis right']
plot_confusion_matrix(labels, pr, names)
plt.show()




for s, subject in enumerate(subjects):
    params = prepDataDecoding(dirs, conditions[0][0], conditions[0][1], subject, baselinecorr, decimate)
    calcDecoding(params, dec_method, dec_scorer, gatordiag)





import matplotlib.pyplot as plt
import numpy as np
from mne.preprocessing import XdawnTransformer
xd = XdawnTransformer(n_components=3)
n_trial, n_chan, n_time = 100, 20, 10
X = np.random.randn(n_trial, n_chan, n_time)
y = np.random.randint(0, 2, n_trial)
xd.fit(X, y)
Xt = xd.transform(X)
X_denoised = xd.inverse_transform(Xt)
plt.matshow(X_denoised.mean(0))
plt.show()