
# Packages
import mne
from fldtrp2mne_calc import fldtrp2mne_calc
import pandas as pd
import numpy as np


def prepDataDecoding(dirs, train_set, test_set, subject, baselinecorr):
    """ Prepare data to
    Example:
    :param dirs: taken from initDirs
    :param train_set: 'op1'
    :param test_set: 'op2'
    :param subject: 's01'
    :param baselinecorr: 'baseline_correct' or baseline_nocorrect
    :return: params
    """

    # Preprocessing
    baseline = (-0.2, -0.05)  # time for the baseline period
    downsampling = 0  # downsampling factor (input at 250Hz)

    # Import epochs calc
    print('importing calc data')
    fname_calc = dirs['data'] + subject + '_calc.mat'  # make this dynamic
    epoch_calc, info_calc = fldtrp2mne_calc(fname_calc, 'data', 'calc')
    times_calc = epoch_calc.times
    print('done')

    if train_set == 'vsa' or test_set == 'vsa':
        print('importing vsa data')
        fname_vsa = dirs['data'] + subject + '_vsa.mat'
        epoch_vsa, info_vsa = fldtrp2mne_calc(fname_vsa, 'data', 'vsa')
        times_vsa = epoch_vsa.times
        print('done')

    # Time lock to the presentation of the result
    print ('timelock result and concate')
    idx_delay = info_calc['delay'] == 1
    idx_nodelay = info_calc['delay'] == 0

    time_calc_crop = np.arange(-0.2, 0.8004, 0.004)

    epoch_calc_delay = epoch_calc[idx_delay]
    epoch_calc_delay.crop(3.4, 4.4)
    epoch_calc_delay.times = time_calc_crop

    epoch_calc_nodelay = epoch_calc[idx_nodelay]
    epoch_calc_nodelay.crop(3.0, 4)
    epoch_calc_nodelay.times = time_calc_crop

    info_calc_delay = info_calc[info_calc['delay'] == 1]
    info_calc_nodelay = info_calc[info_calc['delay'] == 0]
    info_calc_delay['operand'] = info_calc_delay['preResult']  # add another column 'operand' for the big decoder
    info_calc_nodelay['operand'] = info_calc_nodelay['preResult']  # add another column 'operand' for the big decoder

    epoch_calc_reslock = mne.epochs.concatenate_epochs([epoch_calc_delay, epoch_calc_nodelay])
    info_calc_reslock = pd.concat([info_calc_delay, info_calc_nodelay])


    print ('done')

    # Baseline correct if needed
    if baselinecorr == 'baseline':
        print('baseline correcting')
        epoch_calc.apply_baseline(baseline)
        print('done')
    # Downsample data if needed
    if downsampling > 0:
        print('downsampling')
        epoch_calc.decimate(downsampling)
        # epoch_vsa.decimate(downsampling)
        print('done')

    # Select data
    print('selecting data')
    if train_set == test_set:  # Check whether we are training and testing on the same data
        mode = 'cross-validation'
        if train_set == 'cres':
            train_index = (info_calc['corrResult'] >= 3) & (info_calc['corrResult'] <= 6) & (info_calc['operator'] != 0)
            X_train = epoch_calc[train_index]
            y_train = np.array(info_calc[train_index]['corrResult'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -.2, 'stop': 4.4}  # 'length': 0.05 defonce memory!
            test_times = train_times
        elif train_set == 'cres_group':
            info_calc[info_calc['corrResult'] == 4] = 3
            info_calc[info_calc['corrResult'] == 5] = 6
            train_index = (info_calc['corrResult'] >= 3) & (info_calc['corrResult'] <= 6) & (info_calc['operator'] != 0)
            X_train = epoch_calc[train_index]
            y_train = np.array(info_calc[train_index]['corrResult'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -.2, 'stop': 4}  # 'length': 0.05 defonce memory!
            test_times = train_times
        elif train_set == 'cres_len100ms':
            train_index = (info_calc['corrResult'] >= 3) & (info_calc['corrResult'] <= 6) & (info_calc['operator'] != 0)
            X_train = epoch_calc[train_index]
            y_train = np.array(info_calc[train_index]['corrResult'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': 1.5, 'stop': 2.4, 'length': 0.1}
            test_times = train_times
        elif train_set == 'cres_alltimes':
            train_index = (info_calc['corrResult'] >= 3) & (info_calc['corrResult'] <= 6) & (info_calc['operator'] != 0)
            X_train = epoch_calc[train_index]
            y_train = np.array(info_calc[train_index]['corrResult'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': 1.6, 'stop': 2.4}
            test_times = train_times
        elif train_set == 'cres_add':
            train_index = info_calc['operator'] == 1
            X_train = epoch_calc[train_index]
            y_train = np.array(info_calc[train_index]['corrResult'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -.2, 'stop': 4.4}
            test_times = train_times
        elif train_set == 'op2':
            train_index = info_calc['operator'] != 0
            X_train = epoch_calc[train_index]
            y_train = np.array(info_calc[train_index]['operand2'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -.2, 'stop': 4.4}  # 'length': 0.05 defonce memory!
            test_times = train_times
        elif train_set == 'op1':
            train_index = info_calc['operator'] != 0
            X_train = epoch_calc[train_index]
            y_train = np.array(info_calc[train_index]['operand1'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -.2, 'stop': 4.4}  # 'length': 0.05 defonce memory!
            test_times = train_times
        elif train_set == 'addsub':
            train_index = info_calc['operator'] != 0
            X_train = epoch_calc[train_index]
            y_train = np.array(info_calc[train_index]['operator'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -.2, 'stop': 4.4}  # 'length': 0.05 defonce memory!
            test_times = train_times
        elif train_set == 'presTlock':
            train_index = (info_calc_reslock['preResult'] >= 3) & (info_calc_reslock['preResult'] <= 6) & (info_calc_reslock['operator'] != 0)
            X_train = epoch_calc_reslock[train_index]
            y_train = np.array(info_calc_reslock[train_index]['preResult'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.2, 'stop': 0.8}
            test_times = train_times
        elif train_set == 'presTlockCres':
            train_index = (info_calc_reslock['corrResult'] >= 3) & (info_calc_reslock['corrResult'] <= 6) & (info_calc_reslock['operator'] != 0) & (info_calc_reslock['deviant'] != 0)
            X_train = epoch_calc_reslock[train_index]
            y_train = np.array(info_calc_reslock[train_index]['corrResult'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.2, 'stop': 0.8}
            test_times = train_times
        elif train_set == 'op1_len50ms':
            train_index = info_calc['operator'] != 0
            X_train = epoch_calc[train_index]
            y_train = np.array(info_calc[train_index]['operand1'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.1, 'stop': 1.6, 'length': 0.05}
            test_times = train_times
        elif train_set == 'op2_len50ms':
            train_index = info_calc['operator'] != 0
            X_train = epoch_calc[train_index]
            y_train = np.array(info_calc[train_index]['operand2'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': 1.5, 'stop': 3.2, 'length': 0.05}
            test_times = train_times
        elif train_set == 'vsa':
            train_index = info_vsa['congruency'] == 1
            X_train = epoch_vsa[train_index]
            y_train = np.array(info_vsa[train_index]['cue'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.1, 'stop': 1.5}
            test_times = {'start': -0.1, 'stop': 1.5}
    else:
        mode = 'mean-prediction'
        if (train_set == 'op1') & (test_set == 'presTlock'):
            train_index = info_calc['operand1'] != info_calc['preResult']
            X_train = epoch_calc[train_index]
            y_train = np.array(info_calc[train_index]['operand1'])
            y_train = y_train.astype(np.float64)
            test_index = (info_calc_reslock['preResult'] >= 3) & (info_calc_reslock['preResult'] <= 6)
            X_test = epoch_calc_reslock[test_index]
            y_test = np.array(info_calc_reslock[test_index]['preResult'])
            y_test = y_test.astype(np.float64)
            train_times = {'start': -0.2, 'stop': 0.8}
            test_times = {'start': -0.2, 'stop': 0.8}
        elif (train_set == 'op1') & (test_set == 'cres'):
            mode = 'cross-validation' # just to see what happens
            epoch_cres = epoch_calc
            epoch_cres.crop(1.5, 2.4)
            epoch_cres.times = np.arange(-0.1, 0.8004, 0.004)
            epoch_calc.crop(-0.1, 0.8)
            #train_index = info_calc['operand1']
            test_index = (info_calc['corrResult'] >= 3) & (info_calc['corrResult'] <= 6) & (info_calc['operator'] != 0)
            X_train = epoch_calc
            y_train = np.array(info_calc['operand1'])
            y_train = y_train.astype(np.float64)
            X_test = epoch_cres[test_index]
            y_test = np.array(info_calc[test_index]['corrResult'])
            y_test = y_test.astype(np.float64)
            # Update params
            train_times = {'start': -0.1, 'stop': 0.8}
            test_times = {'start': -0.1, 'stop': 0.8}
        elif (train_set == 'presTlockCres') & (test_set == 'cres'):
            # Decimate just to ran faster
            #epoch_calc_reslock.decimate(10)
            #epoch_calc.decimate(10)

            # Set train and test set
            train_index = (info_calc_reslock['corrResult'] >= 3) & (info_calc_reslock['corrResult'] <= 6) & (info_calc_reslock['operator'] != 0) & (info_calc_reslock['deviant'] != 0)
            X_train = epoch_calc_reslock[train_index]
            y_train = np.array(info_calc_reslock[train_index]['corrResult'])
            y_train = y_train.astype(np.float64)

            test_index = (info_calc['corrResult'] >= 3) & (info_calc['corrResult'] <= 6) & (info_calc['operator'] != 0)
            X_test = epoch_calc[test_index]
            y_test = np.array(info_calc_reslock[test_index]['corrResult'])
            y_test = y_test.astype(np.float64)

            train_times = {'start': 0, 'stop': .4}
            test_times = {'start': 1.5, 'stop': 3.2}
        elif (train_set == 'vsa') & (test_set == 'addsub'):
            train_index = info_vsa['congruency'] == 1
            test_index = info_calc['operator'] != 0
            # Correct labels for the cue to match add and sub
            info_vsa[info_vsa['cue'] == 1] = -1
            info_vsa[info_vsa['cue'] == 2] = 1
            X_train = epoch_vsa[train_index]
            y_train = np.array(info_vsa[train_index]['cue'])
            y_train = y_train.astype(np.float64)
            X_test = epoch_calc[test_index]
            y_test = np.array(info_calc[test_index]['operator'])
            y_test = y_test.astype(np.float64)
            # Update params
            train_times = {'start': -0.1, 'stop': 1.5}
            test_times = {'start': 0.7, 'stop': 3.2}
        elif (train_set == 'addsub') & (test_set == 'vsa'):
            train_index = info_calc['operator'] != 0
            test_index = info_vsa['congruency'] == 1
            # Correct labels for the cue to match add and sub
            info_vsa[info_vsa['cue'] == 1] = -1
            info_vsa[info_vsa['cue'] == 2] = 1
            X_train = epoch_calc[train_index]
            y_train = np.array(info_calc[test_index]['operator'])
            y_train = y_train.astype(np.float64)
            X_test = epoch_vsa[test_index]
            y_test = np.array(info_vsa[train_index]['cue'])
            y_test = y_test.astype(np.float64)
            # Update params
            train_times = {'start': 0.7, 'stop': 3.2}
            test_times = {'start': -0.1, 'stop': 1.5}
    print(train_set)
    print(test_set)
    print('done')

    # Organize parameters
    params = {'subject': subject, 'baseline_correction': baselinecorr,
             'train_set': train_set, 'test_set': test_set,
              'train_times': train_times, 'test_times': test_times,
              'times_calc': times_calc,
              'mode': mode,'baseline': baseline, 'downsampling': downsampling,
              'X_train': X_train, 'y_train': y_train, 'X_test': X_test, 'y_test': y_test}

    print(params)

    # params = {'subject': subject,
    #          'train_set': train_set, 'test_set': test_set,
    #           'train_times': train_times, 'test_times': test_times,
    #           'times_calc': times_calc, 'times_vsa': times_vsa,
    #           'mode': mode,'baseline': baseline, 'downsampling': downsampling,
    #           'X_train': X_train, 'y_train': y_train, 'X_test': X_test, 'y_test': y_test}

    return params


