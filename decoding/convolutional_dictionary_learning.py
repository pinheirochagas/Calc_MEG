# Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')

from alphacsc import learn_d_z, update_d_block
from alphacsc.utils import plot_data # noqa
from functools import partial
from prepDataDecoding import prepDataDecoding
from initDirs import dirs
from mne.decoding import UnsupervisedSpatialFilter
from sklearn.decomposition import PCA, FastICA
import mne
import numpy as np
from alphacsc.utils import plot_data # noqa
import matplotlib.pyplot as plt

# Import data
subjects = ['s03']

# Basic parameters
conditions = [['cres_aCSC', 'cres_aCSC']]
baselinecorr = 'nobaseline'
dec_method = 'general' # class reg classGeneral
dec_scorer = 'accuracy' # accuracy or kendall_score
gatordiag = 'diagonal'
decimate = 10

params = prepDataDecoding(dirs, conditions[0][0], conditions[0][1], subjects[0], baselinecorr, decimate)
epochs = params['X_train']
X = params['X_train'].get_data()

# Basic vizualization
evoked = epochs.average()
evoked.plot(gfp=True)

# Run ICA and vizualize
n_comp = 20

ica = UnsupervisedSpatialFilter(FastICA(n_comp), average=False)
ica_data = ica.fit_transform(X)
ev1 = mne.EvokedArray(np.mean(ica_data, axis=0),
                      mne.create_info(n_comp, epochs.info['sfreq'],
                                      ch_types='mag'), tmin=epochs.tmin)
ev1.plot(show=False, window_title='ICA')


### Run Vanilla CSC for each component
#Specs
n_atoms = 2                # K
n_times_atom = 20          # L
n_times = ica_data.shape[2]    # T
n_trials = ica_data.shape[0]   # N
n_iter = 200
reg = 0.1
random_state = 60
func = partial(update_d_block, projection='dual')

for i in ica_data.shape[1]:
# Select 1 component
    Xica = ica_data[:,i,:]
    pobj, times, d_hat, Z_hat = learn_d_z(Xica, n_atoms, n_times_atom, func_d=func, reg=reg, n_iter=n_iter,
        solver_d_kwargs=dict(factr=100), random_state=random_state,
        n_jobs=1, solver_z='l_bfgs', verbose=1)
    plt.plot(d_hat.T)
