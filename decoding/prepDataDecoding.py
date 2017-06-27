
# Packages
import mne
from fldtrp2mne_calc import fldtrp2mne_calc
import pandas as pd
import numpy as np
from epochsTimeLock import resultTL, responseTL


def prepDataDecoding(dirs, train_set, test_set, subject, baselinecorr, decimate):
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
    #decimate = 10  # downsampling factor (input at 250Hz)

    # Import epochs calc
    print('importing calc data')
    fname_calc = dirs['data'] + subject + '_calc_lp30.mat'  # make this dynamic
    #fname_calc = dirs['data'] + subject + '_calc_AICA_acc.mat'  # make this dynamic
    epoch_calc, info_calc = fldtrp2mne_calc(fname_calc, 'data', 'calc')
    epoch_calc.decimate(decimate)
    print('done')

    #Import epoch VSA in case
    if train_set == 'vsa' or test_set == 'vsa':
        print('importing vsa data')
        fname_vsa = dirs['data'] + subject + '_vsa_lp30.mat'
        epoch_vsa, info_vsa = fldtrp2mne_calc(fname_vsa, 'data', 'vsa')
        times_vsa = epoch_vsa.times
        print('done')

    # Baseline correct if needed
    if baselinecorr == 'baseline':
        print('baseline correcting')
        epoch_calc.apply_baseline(baseline)
        print('done')
    # Downsample data if needed
    # #if decimate > 0:
    #     print('downsampling')
    #     epoch_calc.decimate(decimate)
    #     # epoch_vsa.decimate(decimate)
    #     print('done')

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
            #train_times = {'start': 1.5, 'stop': 2}  # 'length': 0.05 defonce memory!
            train_times = {'start': 1.6, 'stop': 2}  # 'length': 0.05 defonce memory!
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
            train_times = {'start': -.2, 'stop': 3.2}  # 'length': 0.05 defonce memory!
            test_times = train_times
        elif train_set == 'addsub':
            train_index = info_calc['operator'] != 0
            X_train = epoch_calc[train_index]
            y_train = np.array(info_calc[train_index]['operator'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -.2, 'stop': 3.2}  # 'length': 0.05 defonce memory!
            test_times = train_times
        elif train_set == 'presTlock':
            train_index = (info_calc_reslock['presResult'] >= 3) & (info_calc_reslock['presResult'] <= 6) & (info_calc_reslock['operator'] != 0)
            X_train = epoch_calc_reslock[train_index]
            y_train = np.array(info_calc_reslock[train_index]['presResult'])
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
            # Response lock
        elif train_set == 'resp_side':
            fname_calc = dirs['data'] + subject + '_calc_lp30_TLresponse.mat'  # make this dynamic
            epoch_calc_resplock, info_calc_resplock = fldtrp2mne_calc(fname_calc, 'data', 'calc')
            epoch_calc_resplock.decimate(decimate)
            train_index = info_calc_resplock['accuracy'] == 1
            X_train = epoch_calc_resplock[train_index]
            y_train = np.array(info_calc_resplock[train_index]['respSide'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.6, 'stop': -0.004}
            test_times = train_times
        elif train_set == 'choice':
            fname_calc = dirs['data'] + subject + '_calc_lp30_TLresponse.mat'  # make this dynamic
            epoch_calc_resplock, info_calc_resplock = fldtrp2mne_calc(fname_calc, 'data', 'calc')
            epoch_calc_resplock.decimate(decimate)
            train_index = (info_calc_resplock['accuracy'] == 1) & (info_calc_resplock['operator'] != 0)
            X_train = epoch_calc_resplock[train_index]
            y_train = np.array(info_calc_resplock[train_index]['correct_choice'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.6, 'stop': -0.004}
            test_times = train_times
        elif train_set == 'correctness':
            fname_calc = dirs['data'] + subject + '_calc_lp30_TLresponse.mat'  # make this dynamic
            epoch_calc_resplock, info_calc_resplock = fldtrp2mne_calc(fname_calc, 'data', 'calc')
            epoch_calc_resplock.decimate(decimate)
            train_index = (info_calc_resplock['accuracy'] == 1) & (info_calc_resplock['operator'] != 0)
            X_train = epoch_calc_resplock[train_index]
            y_train = np.array(info_calc_resplock[train_index]['deviant'])
            y_train[y_train != 0] = 1
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.6, 'stop': -0.004}
            test_times = train_times
        elif train_set == 'resplock_cres':
            fname_calc = dirs['data'] + subject + '_calc_lp30_TLresponse.mat'  # make this dynamic
            epoch_calc_resplock, info_calc_resplock = fldtrp2mne_calc(fname_calc, 'data', 'calc')
            epoch_calc_resplock.decimate(decimate)
            train_index = (info_calc_resplock['corrResult'] >= 3) & (info_calc_resplock['corrResult'] <= 6) & (info_calc_resplock['operator'] != 0) & (info_calc_resplock['accuracy'] == 1)
            X_train = epoch_calc_resplock[train_index]
            y_train = np.array(info_calc_resplock[train_index]['corrResult'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.6, 'stop': -0.004}
            test_times = train_times
        elif train_set == 'resplock_pres':
            fname_calc = dirs['data'] + subject + '_calc_lp30_TLresponse.mat'  # make this dynamic
            epoch_calc_resplock, info_calc_resplock = fldtrp2mne_calc(fname_calc, 'data', 'calc')
            epoch_calc_resplock.decimate(decimate)
            train_index = (info_calc_resplock['presResult'] >= 3) & (info_calc_resplock['presResult'] <= 6) & (info_calc_resplock['operator'] != 0) & (info_calc_resplock['accuracy'] == 1)
            X_train = epoch_calc_resplock[train_index]
            y_train = np.array(info_calc_resplock[train_index]['presResult'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.6, 'stop': -0.004}
            test_times = train_times
        elif train_set == 'resplock_op1':
            fname_calc = dirs['data'] + subject + '_calc_lp30_TLresponse.mat'  # make this dynamic
            epoch_calc_resplock, info_calc_resplock = fldtrp2mne_calc(fname_calc, 'data', 'calc')
            epoch_calc_resplock.decimate(decimate)
            train_index = (info_calc_resplock['accuracy'] == 1) & (info_calc_resplock['operator'] != 0)
            X_train = epoch_calc_resplock[train_index]
            y_train = np.array(info_calc_resplock[train_index]['operand1'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.6, 'stop': -0.004}
            test_times = train_times
        elif train_set == 'resplock_op2':
            fname_calc = dirs['data'] + subject + '_calc_lp30_TLresponse.mat'  # make this dynamic
            epoch_calc_resplock, info_calc_resplock = fldtrp2mne_calc(fname_calc, 'data', 'calc')
            epoch_calc_resplock.decimate(decimate)
            train_index = (info_calc_resplock['accuracy'] == 1) & (info_calc_resplock['operator'] != 0)
            X_train = epoch_calc_resplock[train_index]
            y_train = np.array(info_calc_resplock[train_index]['operand2'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.6, 'stop': -0.004}
            test_times = train_times
        elif train_set == 'resplock_operator':
            fname_calc = dirs['data'] + subject + '_calc_lp30_TLresponse.mat'  # make this dynamic
            epoch_calc_resplock, info_calc_resplock = fldtrp2mne_calc(fname_calc, 'data', 'calc')
            epoch_calc_resplock.decimate(decimate)
            train_index = (info_calc_resplock['accuracy'] == 1) & (info_calc_resplock['operator'] != 0)
            X_train = epoch_calc_resplock[train_index]
            y_train = np.array(info_calc_resplock[train_index]['operator'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.6, 'stop': -0.004}
            test_times = train_times
            # Result lock
        elif train_set == 'resultlock_cres':
            fname_calc = dirs['data'] + subject + '_calc_lp30_TLresult.mat'  # make this dynamic
            epoch_calc_reslock, info_calc_reslock = fldtrp2mne_calc(fname_calc, 'data', 'calc')
            epoch_calc_reslock.decimate(decimate)
            train_index = (epoch_calc_reslock['corrResult'] >= 3) & (epoch_calc_reslock['corrResult'] <= 6) & (epoch_calc_reslock['operator'] != 0) & (epoch_calc_reslock['accuracy'] == 1)
            X_train = epoch_calc_reslock[train_index]
            y_train = np.array(info_calc_reslock[train_index]['corrResult'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.2, 'stop': .8}
            test_times = train_times
        elif train_set == 'resultlock_pres':
            fname_calc = dirs['data'] + subject + '_calc_lp30_TLresult.mat'  # make this dynamic
            epoch_calc_reslock, info_calc_reslock = fldtrp2mne_calc(fname_calc, 'data', 'calc')
            epoch_calc_reslock.decimate(decimate)
            train_index = (epoch_calc_reslock['presResult'] >= 3) & (epoch_calc_reslock['presResult'] <= 6) & (epoch_calc_reslock['operator'] != 0) & (epoch_calc_reslock['accuracy'] == 1)
            X_train = epoch_calc_reslock[train_index]
            y_train = np.array(info_calc_reslock[train_index]['presResult'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.2, 'stop': .8}
            test_times = train_times
        elif train_set == 'resultlock_op1':
            fname_calc = dirs['data'] + subject + '_calc_lp30_TLresult.mat'  # make this dynamic
            epoch_calc_reslock, info_calc_reslock = fldtrp2mne_calc(fname_calc, 'data', 'calc')
            epoch_calc_reslock.decimate(decimate)
            train_index = (epoch_calc_reslock['accuracy'] == 1) & (epoch_calc_reslock['operator'] != 0)
            X_train = epoch_calc_reslock[train_index]
            y_train = np.array(info_calc_reslock[train_index]['operand1'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.2, 'stop': .8}
            test_times = train_times
        elif train_set == 'resultlock_op2':
            fname_calc = dirs['data'] + subject + '_calc_lp30_TLresult.mat'  # make this dynamic
            epoch_calc_reslock, info_calc_reslock = fldtrp2mne_calc(fname_calc, 'data', 'calc')
            epoch_calc_reslock.decimate(decimate)
            train_index = (epoch_calc_reslock['accuracy'] == 1) & (epoch_calc_reslock['operator'] != 0)
            X_train = epoch_calc_reslock[train_index]
            y_train = np.array(info_calc_reslock[train_index]['operand2'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.2, 'stop': .8}
            test_times = train_times
        elif train_set == 'resultlock_operator':
            fname_calc = dirs['data'] + subject + '_calc_lp30_TLresult.mat'  # make this dynamic
            epoch_calc_reslock, info_calc_reslock = fldtrp2mne_calc(fname_calc, 'data', 'calc')
            epoch_calc_reslock.decimate(decimate)
            train_index = (epoch_calc_reslock['accuracy'] == 1) & (epoch_calc_reslock['operator'] != 0)
            X_train = epoch_calc_reslock[train_index]
            y_train = np.array(info_calc_reslock[train_index]['operator'])
            y_train = y_train.astype(np.float64)
            X_test = X_train
            y_test = y_train
            train_times = {'start': -0.2, 'stop': .8}
            test_times = train_times
    else:
        mode = 'mean-prediction'
        if (train_set == 'op1') & (test_set == 'presTlock'):
            train_index = info_calc['operand1'] != info_calc['presResult']
            X_train = epoch_calc[train_index]
            y_train = np.array(info_calc[train_index]['operand1'])
            y_train = y_train.astype(np.float64)
            test_index = (info_calc_reslock['presResult'] >= 3) & (info_calc_reslock['presResult'] <= 6)
            X_test = epoch_calc_reslock[test_index]
            y_test = np.array(info_calc_reslock[test_index]['presResult'])
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
            #epoch_calc_reslock.decimate(decimate)
            #epoch_calc.decimate(decimate)

            # Set train and test set
            train_index = (info_calc_reslock['corrResult'] >= 3) & (info_calc_reslock['corrResult'] <= 6) & (info_calc_reslock['operator'] != 0)
            #train_index = (info_calc_reslock['corrResult'] >= 3) & (info_calc_reslock['corrResult'] <= 6) & (info_calc_reslock['operator'] != 0) & (info_calc_reslock['deviant'] != 0)
            X_train = epoch_calc_reslock[train_index]
            y_train = np.array(info_calc_reslock[train_index]['corrResult'])
            y_train = y_train.astype(np.float64)

            test_index = (info_calc['corrResult'] >= 3) & (info_calc['corrResult'] <= 6) & (info_calc['operator'] != 0)
            X_test = epoch_calc[test_index]
            y_test = np.array(info_calc_reslock[test_index]['corrResult'])
            y_test = y_test.astype(np.float64)

            train_times = {'start': 0, 'stop': .4}
            test_times = {'start': 1.5, 'stop': 3.2}
            #train_times = {'start': 0, 'stop': .1}
            #test_times = {'start': 1.5, 'stop': 1.6}

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
              'times_calc': epoch_calc.times,
              'mode': mode,'baseline': baseline, 'decimate': decimate,
              'X_train': X_train, 'y_train': y_train, 'X_test': X_test, 'y_test': y_test}

    print(params)

    # params = {'subject': subject,
    #          'train_set': train_set, 'test_set': test_set,
    #           'train_times': train_times, 'test_times': test_times,
    #           'times_calc': times_calc, 'times_vsa': times_vsa,
    #           'mode': mode,'baseline': baseline, 'downsampling': downsampling,
    #           'X_train': X_train, 'y_train': y_train, 'X_test': X_test, 'y_test': y_test}

    return params


