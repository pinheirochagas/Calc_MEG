# Import
import mne
from fldtrp2mne_calc import fldtrp2mne_calc
import pandas as pd
import numpy as np

from sklearn.preprocessing import StandardScaler
import matplotlib.pyplot as plt
from matplotlib import cm, pyplot as plt
from matplotlib.dates import YearLocator, MonthLocator


# Dirs
root = '/Volumes/NO_NAME/'
dirs = ({'data': root + 'data/'})

# Subjects
subjects = ['s02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']
subject = 's17'


# Import epochs calc
print('importing calc data')
fname_calc = dirs['data'] + subject + '_calc_lp30.mat'
epoch_calc, info_calc = fldtrp2mne_calc(fname_calc, 'data', 'calc')
print('done')


## crop data
epoch_calc.crop(-0.2, 3.2)

# Decimate data
# the imported data is sampled at 250hz, if you want you can decimate to 125hz to make it more treatable.
# This means that after you will have 1 sample every 8ms, which is good enough.
decimate = 2
epoch_calc.decimate(2)
# you can ignore the RuntimeWarning.

# The data
# Lets first select only the gradiometers (as I told you, I used scikit learn's StandardScaler to combine gradiometers
# and magnetometers)
epoch_calc.pick_types(meg='grad')
data = epoch_calc._data
print(data.shape)
# (421, 204, 625)
# now the data is a 3d np array with: 421 trials X 204 sensors X 625 timepoints
# the exact number of trials will vary across subjects (because of preprocessing)

# Timing of the events: A +/- B = C Cdelayed (see methods)
t_events = ({'A': 0, 'sign': 0.785, 'B': 1.57, 'equal': 2.355, 'C': 3.14, 'Cd': 3.5325})
# So we are basically interested in decoding the results from B to C.

# Trial info
info_calc # contrains all you need to know about the trials
# Operator 0 refers to 'comparison trials', in which subjects saw A = = = C, so you can ignore those
# For most decoding analysis of the correct result, I only used:
train_index = info_calc['operator'] != 0
# As I mentioned before, there is still a operation bias here: additions produce more 6 and subtractions more 3.

# So we can go ahead and define our train and test set as well as our labels
X_train = epoch_calc[train_index]
y_train = np.array(info_calc[train_index]['corrResult'])
# The test set will be the same as the train set, so in this case we must use cross validation.
# For cross validation, I used scikit learn' cv = StratifiedKFold(y_train, 8);
X_test = X_train
y_test = y_train
# Since in most cases the classes will still be slightly unbalanced, I used scikit learn's
# model = svm.SVC(C=1, kernel='linear', class_weight='balanced'), but you could just trim the trials

# Next I used MNE-python' handy functions to perform the classification at each time point and also to train in time = n
# and test in time = n+1, n+2 ,etc. what is known as generalization across time.
# See documentation at MNE-python website.
# You basically only need to define the timings:
train_times = {'start': -.2, 'stop': 3.2}
test_times = train_times

# If you don't want to use MNE-python, you can just grap the np array and labels and you are ready to go!
X_train = X_train._data
y_train


# You could try to concatenate everybody and have a huge training set and then test it in single subjects using
# neural networks.

# Or you could use adversarial learning to try to prevent the classifier of using the info of the operation sign.

### Fingers crossed ! ###
occipital = mne.read_selection('Left-occipital')
occipital = [occipital[i].replace(' ', '') for i in range(len(occipital))]
picks = mne.pick_types(X_train.info, meg='grad', selection=occipital)

X_train._data = X_train._data[:,picks,:]

data = X_train._data
data

X = np.reshape(data, data.shape[0]*data.shape[1]*data.shape[2], 1)
scaler = StandardScaler()
StandardScaler(copy=True, with_mean=True, with_std=True)
X = scaler.transform(X)

X = np.expand_dims(X, axis=1)
lengths = np.repeat(data.shape[2], X.shape[0]/data.shape[2])

model = hmm.GaussianHMM(n_components=4).fit(X, lengths)
hidden_states = model.predict(X,lengths)


print("Transition matrix")
print(model.transmat_)
print()

print("Means and vars of each hidden state")
for i in range(model.n_components):
    print("{0}th hidden state".format(i))
    print("mean = ", model.means_[i])
    print("var = ", np.diag(model.covars_[i]))
    print()

fig, axs = plt.subplots(model.n_components, sharex=True, sharey=True)
colours = cm.rainbow(np.linspace(0, 1, model.n_components))
for i, (ax, colour) in enumerate(zip(axs, colours)):
    # Use fancy indexing to plot data in each state.
    mask = hidden_states == i
    ax.plot_date(dates[mask], close_v[mask], ".-", c=colour)
    ax.set_title("{0}th hidden state".format(i))

    # Format the ticks.
    ax.xaxis.set_major_locator(YearLocator())
    ax.xaxis.set_minor_locator(MonthLocator())

    ax.grid(True)

plt.show()


hidden_states_sh = np.reshape(hidden_states, [data.shape[0],data.shape[1],data.shape[2]])
mean_hs = np.mean(hidden_states_sh,axis=0)


plt.plot(np.mean(mean_hs, axis=0))




Neuromag=read_raw_fif(sample.data_path() + '/MEG/sample/sample_audvis_raw.fif')