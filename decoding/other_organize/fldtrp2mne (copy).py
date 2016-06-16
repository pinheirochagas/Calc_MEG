###Purpose: This function converts data from a fieldtrip structure to mne epochs. 
###Project: General

#Load libraries
import numpy as np
import scipy.io as sio
import pandas as pd
from mne.io.meas_info import create_info
from mne.epochs import EpochsArray

def fldtrp2mne_calc(filename, var, experiment):
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
    time = ft_data.time[0];
    coi = range(306) #channels of interest
    data = data[:, coi, :]
    #chan_names = [l.encode('ascii') for l in ft_data.label[coi]] #this always appends the letter b before the actual filename?
    chan_names = ft_data.label.tolist()
    chan_types = ft_data.label[coi]
    chan_types[0 : 305 : 3] = 'grad'
    chan_types[1 : 305 : 3] = 'grad'
    chan_types[2 : 306 : 3] = 'mag'
    
    #Create info and epochs
    info = create_info(chan_names, sfreq, chan_types)
    events = np.c_[np.cumsum(np.ones(n_trial)) * 5 * sfreq,
                   np.zeros(n_trial), np.zeros(n_trial)]
    epochs = EpochsArray(data, info, events = np.array(events, int),
                         tmin = np.min(time), verbose = False)

    #Recover trialinfo
    trialinfo = mat[var]['trialinfo']  

    if experiment == 'calc':
        run = trialinfo[0][0][0][0][0].T
        operand1 = trialinfo[0][0][0][0][1].T
        operator = trialinfo[0][0][0][0][2].T
        operand2 = trialinfo[0][0][0][0][3].T
        preResult = trialinfo[0][0][0][0][4].T
        delay = trialinfo[0][0][0][0][5].T
        corrResult = trialinfo[0][0][0][0][6].T
        deviant = trialinfo[0][0][0][0][7].T
        absdeviant = trialinfo[0][0][0][0][8].T
        rt = trialinfo[0][0][0][0][9].T
        respSide = trialinfo[0][0][0][0][10].T
        info = pd.DataFrame(data = np.concatenate((run, operand1, operator, operand2, preResult, delay, corrResult, deviant, absdeviant, rt, respSide), axis = 1), 
                        columns = ['run', 'operand1', 'operator', 'operand2', 'preResult', 'delay', 'corrResult', 'deviant', 'absdeviant', 'rt', 'respSide'])
    elif experiment == 'vsa':
        run = trialinfo[0][0][0][0][0].T
        cue = trialinfo[0][0][0][0][1].T
        targetAll = trialinfo[0][0][0][0][2].T
        target = trialinfo[0][0][0][0][3].T
        targetSide = trialinfo[0][0][0][0][4].T
        congruency = trialinfo[0][0][0][0][5].T
        rt = trialinfo[0][0][0][0][6].T
        respSide = trialinfo[0][0][0][0][7].T
        info = pd.DataFrame(data = np.concatenate((run, cue, targetAll, target, targetSide, congruency, rt, respSide), axis = 1), 
                            columns = ['run', 'cue', 'targetAll', 'target', 'targetSide', 'congruency', 'rt', 'respSide'])

    return epochs, info