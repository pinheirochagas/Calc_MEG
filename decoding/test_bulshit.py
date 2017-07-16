from __future__ import division
# Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
from calcDecoding import calcDecodingAlltimes
import numpy as np
from classifyRiemann import classifyRiemann
import pandas as pd
from prepDataDecTFA import prepDataDecTFA
from combineSubsDecoding import combineSubsDecoding

#Basics
#List of parameters
subjects = ['s02', 's03']

baselinecorr = 'nobaseline'
dec_method = 'class'  # or 'class'
dec_scorer = 'accuracy'  # or 'accuracy' kendall_score
gatordiag = 'gat'
conditions = [['op1', 'op1']]
sfreq = 125
chance = .25  # chance-level
complete = 'no'

# Prepare results
res = combineSubsDecoding(subjects, baselinecorr, dec_method, dec_scorer, gatordiag, conditions, sfreq, chance, complete)
#
# # Plot
# # Libraries
# import matplotlib.pyplot as plt
# from jr.plot import base, gat_plot, pretty_gat, pretty_decod, pretty_slices
# from initDirs import dirs
# import numpy as np
#
# #Times
# res['all_diagonals'].shape
# times = np.arange(res['train_times']['start'],res['train_times']['stop']+1/sfreq,1/sfreq)
# times2 = np.arange(res['train_times']['start'],res['train_times']['stop'],1/sfreq)
# times = None
#
#
# #Diagonal group with uncorrected p values
# plt.figure(num=None, figsize=(7,4), dpi=100, facecolor='w', edgecolor='k')
# for c, cond in enumerate(conditions):
#         print (cond)
#         #print(times[np.where(p_values_diagonal[c, :] < .05)])
#         pretty_decod(res['all_diagonals'][c, :, :], times=times2, chance=chance, sig=res['p_values_diagonal'][c, :] < 0.05,
#                  color=[1,0,0], fill=True, xlabel='Times (s)', sfreq=sfreq, smoothWindow=1)