# Libraries
import sys
sys.path.append('/neurospin/meg/meg_tmp/Calculation_Pedro_2014/scripts/decoding')
from initDirs import dirs
from prepDataDecoding import prepDataDecoding
from calcDecoding import calcDecoding
from calcDecoding import calcDecodingAlltimes
import numpy as np

subject = 's03'
params = prepDataDecoding(dirs, 'presTlockCres', 'cres', subject, 'baseline_nocorrect')
calcDecoding(params, 'class', 'accuracy', 'gat')



fname = dirs['result'] + cond[0] + '_' + cond[1] + subject + '_' + cond[0] + '_' + cond[1] + '_' + dec_method + '_' +
                dec_scorer + '_' + gatordiag '_' + baselinecorr + '_' + '.npy'