###Purpose: This function converts data from a fieldtrip structure to python.

# Load libraries
import pandas as pd
from scipy.io import loadmat


def fldtrp2python(filename):
    """ Converts mat fieldtrip structure to python"""

    data = loadmat(filename, squeeze_me=True, struct_as_record=False)

    info = pd.DataFrame(columns=data['trialinfo']._fieldnames)
    for attr, value in enumerate(data['trialinfo']._fieldnames):
        info[value] = data['trialinfo'].__dict__[value]

    data = data['TFR'].powspctrm

    return data, info





