###Purpose: This function converts ecog data from a fieldtrip structure to mne epochs.
###Project: General
###Author: Pinheiro-Chagas
###Date: 14 January 2016

#Load libraries
import numpy as np
import scipy.io as sio
import pandas as pd
from mne.io.meas_info import create_info
from mne.epochs import EpochsArray

def ecog2mne_calculia(filename, var, experiment):
    "This function converts data from a fieldtrip structure to mne epochs"
    
    #Load Matlab/fieldtrip data
    mat = sio.loadmat(filename, squeeze_me = True, struct_as_record = False)
    ft_data = mat[var]
    
    #Identify basic parameters
    n_trial = len(ft_data.trial)
    n_chans, n_time = ft_data.trial[0].shape #ATTENTION: This presumes equal epoch lengths across trials
    data = np.zeros((n_trial, n_chans, n_time))
    
    for triali in range(n_trial):
        data[triali, :, :] = ft_data.trial[triali]
    
    #Add all necessary info
    sfreq = float(ft_data.fsample) #sampling frequency
    #lpFilter = float(ft_data.cfg.lpfreq)
    time = ft_data.time[0]; # probably need to change that to ft_data.time only
    coi = range(n_chans) #channels of interest 
    # ALSO NEED TO CHANGE THAT! According to each subject
    data = data[:, coi, :]
    #chan_names = [l.encode('ascii') for l in ft_data.label[coi]] #this always appends the letter b before the actual filename?
    chan_names = ft_data.label.tolist()
    chan_types = 'ecog'
    #chan_types = ft_data.label[coi]
    #chan_types[1 : 106] = 'ecg'

    #Create info and epochs
    info = create_info(chan_names, sfreq, chan_types)
    events = np.c_[np.cumsum(np.ones(n_trial)) * 5 * sfreq,
                   np.zeros(n_trial), np.zeros(n_trial)]
    epochs = EpochsArray(data, info, events = np.array(events, int),
                         tmin = np.min(time), verbose = False)

    #Recover trialinfo
    matinfo = sio.loadmat(filename)
    trialinfo = matinfo['data']['trialinfo']  

    if experiment == 'context':
        run = trialinfo[0][0][0][0][0].T
        operand1 = trialinfo[0][0][0][0][5].T
        operand2 = trialinfo[0][0][0][0][6].T
        operator = trialinfo[0][0][0][0][9].T
        preResult = trialinfo[0][0][0][0][10].T
        corResult = trialinfo[0][0][0][0][11].T
        deviant = trialinfo[0][0][0][0][13].T

        info = pd.DataFrame(data = np.concatenate((run, operand1, operand2, operator, preResult, corResult, deviant), axis = 1), 
                        columns = [ 'run', 'operand1', 'operand2', 'operator', 'preResult', 'corResult', 'deviant',])
    elif experiment == 'calculia':
        run = trialinfo[0][0][0][0][0].T
        operand1 = trialinfo[0][0][0][0][5].T
        operand2 = trialinfo[0][0][0][0][6].T
        operator = trialinfo[0][0][0][0][9].T
        preResult = trialinfo[0][0][0][0][10].T
        corResult = trialinfo[0][0][0][0][11].T
        deviant = trialinfo[0][0][0][0][13].T

        info = pd.DataFrame(data = np.concatenate((run, operand1, operand2, operator, preResult, corResult, deviant), axis = 1), 
                        columns = [ 'run', 'operand1', 'operand2', 'operator', 'preResult', 'corResult', 'deviant',])
    

    return epochs, info