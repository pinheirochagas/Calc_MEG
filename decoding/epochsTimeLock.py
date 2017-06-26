#Libraries
import mne
import pandas as pd
import numpy as np
from __future__ import division


# to delete
from initDirs import dirs
from fldtrp2mne_calc import fldtrp2mne_calc

fname_calc = dirs['data'] + subject + '_calc_lp25_250hz.mat'  # make this dynamic
# fname_calc = dirs['data'] + subject + '_calc_AICA_acc.mat'  # make this dynamic

epoch_calc, info_calc = fldtrp2mne_calc(fname_calc, 'data', 'calc')


def resultTL(info_calc, epoch_calc):

    # Time lock to the presentation of the result
    print ('timelock result and concate')
    idx_delay = info_calc['delay'] == 1
    idx_nodelay = info_calc['delay'] == 0

    time_calc_crop = np.arange(-0.2, 0.8004, 0.004) # Sensitive line, depends on frquency sample

    epoch_calc_delay = epoch_calc[idx_delay]
    epoch_calc_delay.crop(3.4, 4.4)
    epoch_calc_delay.times = time_calc_crop

    epoch_calc_nodelay = epoch_calc[idx_nodelay]
    epoch_calc_nodelay.crop(3.0, 4)
    epoch_calc_nodelay.times = time_calc_crop

    info_calc_delay = info_calc[info_calc['delay'] == 1]
    info_calc_nodelay = info_calc[info_calc['delay'] == 0]
    #info_calc_delay['operand'] = info_calc_delay['presResult']  # add another column 'operand' for the big decoder
    #info_calc_nodelay['operand'] = info_calc_nodelay['presResult']  # add another column 'operand' for the big decoder

    epoch_calc_reslock = mne.epochs.concatenate_epochs([epoch_calc_delay, epoch_calc_nodelay])
    info_calc_reslock = pd.concat([info_calc_delay, info_calc_nodelay])

    return epoch_calc_reslock, info_calc_reslock

def responseTL(info_calc, epoch_calc):

    # initialize
    good_trials = np.zeros(epoch_calc._data.shape[0])
    locked_data = np.array([])
    for i in range(0,epoch_calc._data.shape[0]):
        if info_calc['delay'][i] == 1:
            timeEpoch = 3.6 + info_calc['rt'][i]/1000
        else:
            timeEpoch = 3.2 + info_calc['rt'][i] / 1000

        if timeEpoch <= np.max(epoch_calc.times):
            good_trials[i] = 1
            time_resp = int(round((abs(np.min(epoch_calc.times))+timeEpoch)*epoch_calc.info['sfreq']))
            time_before_resp = int(round((abs(np.min(epoch_calc.times))+timeEpoch)*epoch_calc.info['sfreq']) - round(.600*epoch_calc.info['sfreq']))
            locked_data = np.append(locked_data, epoch_calc._data[i,:, range(time_before_resp, time_resp)])
        else:
            good_trials[i] = 0
            print str((len(good_trials)-sum(good_trials))) + ' trials lost'

    epoch_calc._data = WORK FROM HERE

    return epoch_calc_resplock, info_calc_resplock