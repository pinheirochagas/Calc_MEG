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
                         tmin = np.min(time), verbose = False) # or tmin = 0
    #epochs.times = time # correct timing (was having problem with downsampled to 125hz)

    #Recover trialinfo
    if experiment == 'calc':
        run = np.expand_dims(ft_data.trialinfo.run, axis=0).T
        operand1 = np.expand_dims(ft_data.trialinfo.operand1, axis=0).T
        operator = np.expand_dims(ft_data.trialinfo.operator, axis=0).T
        operand2 = np.expand_dims(ft_data.trialinfo.operand1, axis=0).T
        presResult = np.expand_dims(ft_data.trialinfo.presResult, axis=0).T
        delay = np.expand_dims(ft_data.trialinfo.delay, axis=0).T
        corrResult = np.expand_dims(ft_data.trialinfo.corrResult, axis=0).T
        deviant = np.expand_dims(ft_data.trialinfo.deviant, axis=0).T
        absdeviant = np.expand_dims(ft_data.trialinfo.absdeviant, axis=0).T
        rt = np.expand_dims(ft_data.trialinfo.rt, axis=0).T
        respSide = np.expand_dims(ft_data.trialinfo.respSide, axis=0).T
        accuracy = np.expand_dims(ft_data.trialinfo.accuracy, axis=0).T
        info = pd.DataFrame(
            data=np.concatenate((run, operand1, operator, operand2, presResult, delay, corrResult, deviant, absdeviant, rt, respSide, accuracy),axis=1),
            columns=['run', 'operand1', 'operator', 'operand2', 'presResult', 'delay', 'corrResult','deviant', 'absdeviant', 'rt', 'respSide', 'accuracy'])

    elif experiment == 'vsa':
        run = np.expand_dims(ft_data.trialinfo.run, axis=0).T
        cue = np.expand_dims(ft_data.trialinfo.cue, axis=0).T
        targetAll = np.expand_dims(ft_data.trialinfo.targetAll, axis=0).T
        target = np.expand_dims(ft_data.trialinfo.target, axis=0).T
        targetSide = np.expand_dims(ft_data.trialinfo.targetSide, axis=0).T
        congruency = np.expand_dims(ft_data.trialinfo.congruency, axis=0).T
        rt = np.expand_dims(ft_data.trialinfo.rt, axis=0).T
        respSide = np.expand_dims(ft_data.trialinfo.respSide, axis=0).T
        info = pd.DataFrame(
            data=np.concatenate((run, cue, targetAll, target, targetSide, congruency, rt, respSide), axis=1),
            columns=['run', 'cue', 'targetAll', 'target', 'targetSide', 'congruency', 'rt', 'respSide'])

    return epochs, info