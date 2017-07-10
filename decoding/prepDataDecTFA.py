
# Libraries
from fldtrp2python import fldtrp2python
import numpy as np


def prepDataDecTFA(dirs, train_set, test_set, subject):
    """ Prepare data for decoding TFA """

    # Import epochs calc
    print('importing calc data')
    fname_calc = dirs['TFA_data'] + subject + '_TFA_cres_calc.mat'  # make this dynamic
    data, info = fldtrp2python(fname_calc)
    print('done')

    # Select data
    print('selecting data')
    if train_set == 'cres_freq_riemann':
        train_index = (info['corrResult'] >= 3) & (info['corrResult'] <= 6) & (info['operator'] != 0)
        X = data[train_index,:,:]
        y = np.array(info[train_index]['corrResult'])
        y = y.astype(np.float64)
    elif train_set == 'op2_freq_riemann':
        train_index = info['operator'] != 0
        X = data[train_index,:,:]
        y = np.array(info[train_index]['operand2'])
        y = y.astype(np.float64)

    params = {'subject': subject, 'train_set': train_set, 'test_set': test_set}

    return X, y, params