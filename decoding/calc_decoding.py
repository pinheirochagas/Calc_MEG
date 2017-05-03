# Run classification and regression for conditions within the same task (calc)
# Calc_MEG
# Pinheiro-Chagas - 2016

def calcDecoding(wkdir, condition, subject, type):

    # Load necessary libraries
    import mne
    import os
    import sys
    import os.path as op
    import pandas as pd
    import scipy.io as sio
    from scipy import stats
    import numpy as np
    from fldtrp2mne_calc import fldtrp2mne_calc
    from calc_classification import calc_classification
    from calc_regression import calc_regression
    from calc_decoding_cfg import (result_path)
    cwd = os.path.dirname(os.path.abspath(__file__))
    os.chdir(cwd)

    def prepareData(wkdir, condition, subject, type):

        from calc_decoding_cfg import (data_path, baseline, downsampling, trainTimes, testTimes)

        # Select conditions
        trainset = condition[0]  # and then this will be already known when calling the function
        testset = condition[1]

        params = {'baseline': baseline, 'downsampling': downsampling,
                  'classification': Condition, 'trainset': trainset,
                  'testset': testset, 'trainTimes': trainTimes, 'testTimes': testTimes}

        # Import epochs calc
        fname_calc = data_path + '/' + Subject + '_calc.mat'  # add smoothed once corrected
        epoch_calc, info_calc = fldtrp2mne_calc(fname_calc, 'data', 'calc')
        times_calc = epoch_calc.times

        # Import epochs vsa
        fname_vsa = data_path + '/' + Subject + '_vsa.mat'
        epoch_vsa, info_vsa = fldtrp2mne_calc(fname_vsa, 'data', 'vsa')
        times_vsa = epoch_vsa.times

        # Time lock to the presentation of the result
        idx_delay = info_calc['delay'] == 1
        idx_nodelay = info_calc['delay'] == 0

        time_calc_crop = np.arange(-0.1, 0.8004, 0.004)

        epoch_calc_delay = epoch_calc[idx_delay]
        epoch_calc_delay.crop(3.5, 4.4)
        epoch_calc_delay.times = time_calc_crop

        epoch_calc_nodelay = epoch_calc[idx_nodelay]
        epoch_calc_nodelay.crop(3.1, 4)
        epoch_calc_nodelay.times = time_calc_crop

        info_calc_delay = info_calc[info_calc['delay'] == 1]
        info_calc_nodelay = info_calc[info_calc['delay'] == 0]
        info_calc_delay['operand'] = info_calc_delay['preResult']  # add another column 'operand' for the big decoder
        info_calc_nodelay['operand'] = info_calc_nodelay['preResult']  # add another column 'operand' for the big decoder

        epoch_calc_resplock = mne.epochs.concatenate_epochs([epoch_calc_delay, epoch_calc_nodelay])
        info_calc_resplock = pd.concat([info_calc_delay, info_calc_nodelay])
        print 'concat well'

        # Downsample data if needed
        if downsampling > 0:
            epoch_calc.decimate(downsampling)
            epoch_vsa.decimate(downsampling)

        if trainset[-1] == testset[-1]:  # Check whether we are training and testing on the same data
            mode = 'cross-validation'
            if trainset == 'cres':
                train_index = (info_calc['corrResult'] >= 3) & (info_calc['corrResult'] <= 6) & (info_calc['operand2'] != 0) & (info_calc['operator'] != 0)
                #train_index = info_calc['operator'] != 0
                X_train = epoch_calc[train_index]
                y_train = np.array(info_calc[train_index]['corrResult'])
                y_train = y_train.astype(np.float64)
                X_test = X_train
                y_test = y_train
                trainTimes = {'start': -0.2, 'stop': 2}
                testTimes = {'start': -0.2, 'stop': 2}
                params.update({'trainTimes': trainTimes})
                params.update({'testTimes': testTimes})

        del epoch_calc
        #import ipdb; ipdb.set_trace() # to debug...
        # Update params with mode
        params.update({'mode': mode})
        print('preparing to decode')

        # Decode
        if Type == 'class':
            print('Decoding subject classification')
            gat, score, diagonal = calc_classification(X_train, y_train, X_test, y_test, params)
            scoreR = 'auc'
        elif Type == 'reg':
            print('Decoding subject regression')
            gat, score, diagonal = calc_regression(X_train, y_train, X_test, y_test, params)
            y_predictive = gat.y_pred_
            y_true = gat.y_true_
            gat_scorer = gat.scorer
            scoreR = 'r2'
            del gat
        return params, times_calc, y_predictive, y_true, score, diagonal, y_train, y_test, gat_scorer, scoreR


params, times_calc, y_predictive, y_true, score, diagonal, y_train, y_test, gat_scorer, scoreR = calc_prepDec_wTask_CR(wkdir, Condition, Subject, Type)

results = {'params': params, 'times_calc': times_calc, 'y_predictive': y_predictive, 'y_true': y_true, 'score': score, 'diagonal': diagonal, 'y_train': y_train, 'y_test': y_test}
#results = {'params': params, 'times_calc': times_calc, 'gat': gat, 'score': score, 'diagonal': diagonal}
# do I need to save the gat?
print sys.getsizeof(results)
#Save data
fname = result_path + '/individual_results/' + Subject + '_' + Condition[0] + '_' + Condition[1] + '_results_' + Type + '_' + scoreR
#fname = result_path + '/individual_results/' + Subject + '_' + Condition[0] + '_' + Condition[1] + '_results_' + Type
np.save(fname, results)
