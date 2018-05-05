###Purpose: This function converts ecog data from a avg fieldtrip structure to numpy.
###Project: General
###Author: Pinheiro-Chagas
###Date: May 2018

#Load libraries
import numpy as np
import scipy.io as sio

def ecog2python(filename, var):
    "This function converts data from a fieldtrip structure to mne epochs"
    
    #Load Matlab/fieldtrip data
    mat = sio.loadmat(filename, squeeze_me = True, struct_as_record = False)
    ft_data = mat[var]


    return ft_data.trial