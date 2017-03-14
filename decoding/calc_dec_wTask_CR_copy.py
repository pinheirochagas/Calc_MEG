# Run classification and regression for conditions within the same task (calc)
# Calc_MEG
# Pinheiro-Chagas - 2016

##############################################################################################

def calc_dec_wTask_CR(wkdir, Condition, Subject, Type):  # Type is class or ger

    ##########################################################################################
    # Test input
    # wkdir = '/neurospin/meg/meg_tmp/Calculation_Pedro_2014/'
    # Condition = ['op1', 'op1']
    # Subject = 's01'

    ####################################################################
    # Load necessary libraries
    import mne
    import os
    import os.path as op
    import numpy as np
    import pandas as pd
    import scipy.io as sio
    from scipy import stats
    from fldtrp2mne_calc import fldtrp2mne_calc
    from calc_classification import calc_classification
    from calc_regression import calc_regression
    from calc_decoding_cfg import (result_path)

    cwd = os.path.dirname(os.path.abspath(__file__))
    os.chdir(cwd)

    ##########################################################################################
    # Subfunction

    def calc_prepDec_wTask_CR(wkdir, Condition, Subject, Type):

        ######################################################################################
        # Basic config

        from calc_decoding_cfg import (data_path, baseline, downsampling)
        # Decoding
        trainset = Condition[0]  # and then this will be already known when calling the function
        testset = Condition[1]

        params = {'baseline': baseline, 'downsampling': downsampling,
                  'classification': Condition, 'trainset': trainset,
                  'testset': testset}

        fname = data_path + '/' + Subject + '_calc.mat'
        epoch_calc, info_calc = fldtrp2mne_calc(fname, 'data', 'calc')
        epoch_vsa, info_vsa = fldtrp2mne_calc(fname, 'data', 'vsa')
        epoch_calc.apply_baseline(baseline)
        epoch_vsa.apply_baseline(baseline)

        # Downsample data if needed
        if downsampling > 0:
            epoch_calc.decimate(downsampling)
            epoch_vsa.decimate(downsampling)

        # Select data to use.

        if trainset[-1] == testset[-1]:  # Check whether we are training and testing on the same data
            mode = 'cross-validation'
            if trainset == 'op1':
                X_train = epoch_calc
                y_train = np.array(info_calc['operand1'])
                y_train = y_train.astype(np.float64)
                X_test = X_train
                y_test = y_train
            elif trainset == 'op2':
                X_train = epoch_calc
                y_train = np.array(info_calc['operand2'])
                y_train = y_train.astype(np.float64)
                X_test = X_train
                y_test = y_train
            elif trainset == 'pres':
                X_train = epoch_calc[(info_calc['preResult'] >= 3) & (info_calc['preResult'] <= 6)]
                y_train = np.array(info['preResult'])
                y_train = y_train.astype(np.float64)
                X_test = X_train
                y_test = y_train
            elif trainset == 'cres':
                X_train = epoch_calc[(info_calc['corrResult'] >= 3) & (info_calc['preResult'] <= 6)]
                y_train = np.array(info['corrResult'])
                y_train = y_train.astype(np.float64)
                X_test = X_train
                y_test = y_train
            elif trainset == 'delay_nodelay':
                X_train = epoch_calc
                y_train = np.array(info['delay'])
                y_train = y_train.astype(np.float64)
                X_test = X_train
                y_test = y_train
        else:
            mode = 'mean-prediction'

        # Update params with mode
        params.update({'mode': mode})

        if Type == 'class':
            gat, score, diagonal = calc_classification(X_train, y_train, X_test, y_test, params)
            print('Decoding subject classification')
        elif Type == 'reg':
            gat, score, diagonal = calc_regression(X_train, y_train, X_test, y_test, params)
            print('Decoding subject regression')

        return params, epoch_calc.times, epoch_vsa.times, gat, score, diagonal, gat, score, diagonal

    params, times_calc, times_vsa, gat, score, diagonal, gat, score, diagonal = calc_prepDec_wTask_CR(wkdir, Condition,
                                                                                                      Subject, Type)

    results = {'params': params, 'times_calc': times_calc, 'gat': gat, 'score': score, 'diagonal': diagonal}
    results = {'params': params, 'times_calc': times_calc, 'gat': gat, 'score': score, 'diagonal': diagonal}
    # do I need to save the gat?

    # Save data
    fname = result_path + '/individual_results/' + Subject + '_' + Condition[0] + '_' + Condition[
        1] + '_results_' + Type
    np.save(fname, results)
