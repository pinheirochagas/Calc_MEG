# Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
from calcDecoding import calcDecodingAlltimes
import numpy as np
from classifyGeneral import classifyGeneral
import pandas as pd

# Subjects
subjects = ['s02', 's03', 's04', 's05', 's06', 's07', 's08', 's09', 's10', 's11', 's12', 's13', 's14', 's15', 's16', 's17', 's18', 's19', 's21', 's22']
subjects = ['s02']

# Basic parameters
conditions = [['op2_riemann', 'op2_riemann']]
baselinecorr = 'nobaseline'
dec_method = 'general' # class reg classGeneral
dec_scorer = 'accuracy' # accuracy or kendall_score
gatordiag = 'diagonal'
decimate = 10


for s, subject in enumerate(subjects):
    params = prepDataDecoding(dirs, conditions[0][0], conditions[0][1], subject, baselinecorr, decimate)
    calcDecoding(params, dec_method, dec_scorer, gatordiag)    # or calcDecoding(params, dec_method, dec_scorer, gatordiag)


